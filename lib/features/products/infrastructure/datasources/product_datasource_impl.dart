import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';


class ProductsDatasourceImpl extends ProductsDatasource {

  late final Dio dio;
  final String accesstoken;

  ProductsDatasourceImpl({
    required this.accesstoken
  }): dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl, 
      headers: {
        'Authorization': 'Bearer $accesstoken'
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
     final respose = await dio.get<List>('/api/products?limit=$limit&offset=$offset');
     final List<ProductEntity> products = [];

     for( final product in respose.data ?? [] ) {
      //products.add()
     }

     return products;
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}