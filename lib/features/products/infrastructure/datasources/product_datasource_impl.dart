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


  Future<String> _updateFile( String path ) async {

    try {

      final  filename = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: filename)
      });

      final response = await dio.post('/files/product', data: data );

      return response.data['image'];

    } catch (e) {
      throw Exception();
    }

  }


  Future<List<String>> _uploadPhotos( List<String> photos ) async {

      final photosToUpload = photos.where((element) => element.contains('/') ).toList();
      final photosToIgnore = photos.where((element) => !element.contains('/') ).toList();


      final List<Future<String>> uploadJob = photosToUpload.map( _updateFile ).toList();
      final newImages = await Future.wait(uploadJob);

      return [...photosToIgnore, ...newImages];
  }

  @override
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) async {
   
   try {
     
     final String? productId = productLike['id'];
     final String method = (productId == null) ? 'POST' : 'PATCH';
     final String url = (productId == null) ? '/products' : '/products/$productId';

     productLike.remove('id');
     productLike['images'] = await _uploadPhotos( productLike['images'] );

  

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