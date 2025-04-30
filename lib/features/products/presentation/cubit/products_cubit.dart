import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/features/products/presentation/constants/products_constants.dart';
import '../../domain/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;
  static const int _limit = 100;

  ProductsCubit({
    required ProductsRepository repository,
  })  : _repository = repository,
        super(const ProductsInitial());

  Future<void> loadProducts() async {
    if (state is ProductsLoading) return;

    emit(const ProductsLoading(
      products: [],
      hasReachedMax: false,
      isLoadingMore: false,
    ));

    try {
      final result = await _repository.getProducts(
        limit: _limit,
        skip: 0,
      );

      result.fold(
        (failure) => emit(const ProductsError(
          message: ProductsTexts.loadError,
          products: [],
          hasReachedMax: false,
          isLoadingMore: false,
        )),
        (products) => emit(ProductsLoaded(
          products: products,
          hasReachedMax: products.length < _limit,
          isLoadingMore: false,
        )),
      );
    } catch (error) {
      emit(ProductsError(
        message: error.toString(),
        products: [],
        hasReachedMax: false,
        isLoadingMore: false,
      ));
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
