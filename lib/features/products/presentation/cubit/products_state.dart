import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  final List<Product> products;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ProductsState({
    this.products = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [products, hasReachedMax, isLoadingMore];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial() : super();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading({
    required super.products,
    required super.hasReachedMax,
    required super.isLoadingMore,
  });
}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required super.products,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({
    required this.message,
    required super.products,
    required super.hasReachedMax,
    super.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
