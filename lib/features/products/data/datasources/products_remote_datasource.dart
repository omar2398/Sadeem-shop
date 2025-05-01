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
      print('Making API call to dummyjson.com/products');
      final response = await dio.get(
        'https://dummyjson.com/products',
        queryParameters: {
          'limit': limit == 0 ? 100 : limit,
          'skip': skip,
        },
      );

      final data = response.data;
      final productsJson = data['products'] as List;
      print('Found ${productsJson.length} products in response');

      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('Error in remote data source: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load products: $e');
    }
  }
}
