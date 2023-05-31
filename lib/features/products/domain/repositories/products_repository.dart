import '../../products.dart';

abstract class ProductsRepository {


   Future<ProductEntity> getProductsByPage({ int limit = 10, int offset = 0 });
   Future<ProductEntity> getProductById( String id );

   Future<List<ProductEntity>> searchProductByTerm( String term );

   Future<ProductEntity> createUpdateProduct( Map<String,dynamic> productLike );

}