import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio dio;

  ProductsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      final List<dynamic> productsJson = response.data['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    }
  }
}
