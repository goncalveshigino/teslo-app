import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/products.dart';

import 'providers.dart';



//! STATE NOTIFIER PROVIDER


final productsProvider  = StateNotifierProvider<ProductsNotifier, ProductsState>((ref){

  final productsRepository = ref.watch( productsRepositoryProvider );

  return ProductsNotifier(
     productsRepository: productsRepository
  );
  
});


//! NOTIFIER

class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productsRepository;
  
  ProductsNotifier({
    required this.productsRepository
  }): super( ProductsState() ){
    loadNextPage();
  }

  Future loadNextPage() async {

    if ( state.isLoading || state.isLastPage ) return;

    state = state.copyWith( isLoading: true );
    
      final products = await productsRepository
        .getProductsByPage( limit: state.limit, offset: state.offset );

      if( products.isEmpty ) {
        state = state.copyWith(
          isLoading: false, 
          isLastPage:  true,
        );

        return;
      }

      state = state.copyWith(
        isLastPage: false, 
        isLoading: false, 
        offset: state.offset + 10, 
        products: [...state.products, ...products ]
      );
  }

}



//! STATE
class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<ProductEntity> products;


  ProductsState({
     this.isLastPage = false,
     this.limit = 10,
     this.offset = 0,
     this.isLoading = false,
     this.products = const[],
  });

  ProductsState copyWith(
    { 
      bool? isLastPage, 
      int? limit, 
      int? offset, 
      bool? isLoading, 
      List<ProductEntity>? products,
    }
  ) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage, 
    limit: limit ?? this.limit, 
    offset: offset ?? this.offset, 
    isLoading: isLoading ?? this.isLoading, 
    products: products ?? this.products
  );

}
