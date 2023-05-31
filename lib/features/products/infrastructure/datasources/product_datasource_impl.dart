import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../products.dart';


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
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductEntity> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
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