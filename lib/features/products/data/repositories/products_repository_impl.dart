import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final products = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}