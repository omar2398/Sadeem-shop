import 'package:dio/dio.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login(String username, String password);
  Future<UserModel> getCurrentUser(String token);
  Future<AuthTokensModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<AuthTokensModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    }
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get current user: ${e.message}');
    }
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/auth/refresh',
        data: {
          'refreshToken': refreshToken,
          'expiresInMins': 30,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to refresh token: ${e.message}');
    }
  }
}