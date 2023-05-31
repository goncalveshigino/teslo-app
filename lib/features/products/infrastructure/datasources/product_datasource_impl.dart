import 'package:teslo_shop/features/products/domain/domain.dart';


class ProductsDatasourceImpl extends ProductsDatasource {

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
  Future<ProductEntity> getProductsByPage({int limit = 10, int offset = 0}) {
    // TODO: implement getProductsByPage
    throw UnimplementedError();
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}