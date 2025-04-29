import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;
  static const int _limit = 10;

  ProductsCubit({
    required ProductsRepository repository,
  })  : _repository = repository,
        super(const ProductsInitial());

  Future<void> loadProducts() async {
    emit(ProductsLoading(
      products: [],
      hasReachedMax: false,
      isLoadingMore: false,
    ));

    final result = await _repository.getProducts(
      limit: _limit,
      skip: 0,
    );

    result.fold(
      (failure) => emit(ProductsError(
        message: 'Failed to load products',
        products: [],
        hasReachedMax: false,
        isLoadingMore: false,
      )),
      (products) {
        emit(ProductsLoaded(
          products: products,
          hasReachedMax: products.length < _limit,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (state is ProductsLoading || state.hasReachedMax) return;

    final currentProducts = state.products;
    
    emit(ProductsLoaded(
      products: currentProducts,
      hasReachedMax: false,
      isLoadingMore: true,
    ));

    final result = await _repository.getProducts(
      limit: _limit,
      skip: currentProducts.length,
    );

    result.fold(
      (failure) => emit(ProductsError(
        message: 'Failed to load more products',
        products: currentProducts,
        hasReachedMax: false,
        isLoadingMore: false,
      )),
      (newProducts) {
        final allProducts = [...currentProducts, ...newProducts];
        emit(ProductsLoaded(
          products: allProducts,
          hasReachedMax: newProducts.length < _limit,
          isLoadingMore: false,
        ));
      },
    );
  }
}
