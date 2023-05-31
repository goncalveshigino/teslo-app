import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {

  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<ProductEntity> createUpdateProduct( Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<ProductEntity> getProductById(String id) {
    return datasource.getProductById(id);
  }

  @override
  Future<List<ProductEntity>> getProductsByPage({int limit = 10, int offset = 0}) {
   return datasource.getProductsByPage( limit: limit, offset: offset );
  }

  @override
  Future<List<ProductEntity>> searchProductByTerm(String term) {
    return datasource.searchProductByTerm(term);
  }

}