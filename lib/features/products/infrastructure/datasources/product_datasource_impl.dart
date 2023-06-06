import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../products.dart';
import '../infrastructure.dart';


class ProductsDatasourceImpl extends ProductsDatasource {

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken, 
  }): dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl, 
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );

  @override
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) async {
   
   try {
     
     final String? productId = productLike['id'];
     final String method = (productId == null) ? 'POST' : 'PATCH';
     final String url = (productId == null) ? '/products' : '/products/$productId';

     productLike.remove('id');


     final response = await dio.request(
      url, 
      data: productLike, 
      options: Options(
        method: method
      )
     );

     final product = ProductMapper.jsonToEntity(response.data);
     return product;

   } catch (e) {
     throw Exception();
   }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    
    try {

      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    } on DioError catch(e) {
       if ( e.response!.statusCode == 404 ) throw ProductNotFound(); 
       throw Exception();
    } catch (e) {
       throw Exception();
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByPage({int limit = 10, int offset = 0}) async {
     final respose = await dio.get<List>('/products?limit=$limit&offset=$offset');
     final List<ProductEntity> products = [];

     for( final product in respose.data ?? [] ) {
      products.add( ProductMapper.jsonToEntity(product) );
     }

     return products;
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}