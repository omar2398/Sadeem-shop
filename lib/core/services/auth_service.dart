import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'https://dummyjson.com/auth';
  final _storage = const FlutterSecureStorage();
  late final Dio _dio;

  AuthService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    ));

    // Add interceptor for token handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to request if available
          final tokens = await getStoredTokens();
          if (tokens['accessToken'] != null) {
            options.headers['Authorization'] =
                'Bearer ${tokens['accessToken']}';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshed = await refreshToken();
            if (refreshed) {
              // Retry the original request
              final tokens = await getStoredTokens();
              error.requestOptions.headers['Authorization'] =
                  'Bearer ${tokens['accessToken']}';
              return handler.resolve(await _dio.fetch(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Store tokens
  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Get stored tokens
  Future<Map<String, String?>> getStoredTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 60,
        },
      );

      if (response.statusCode == 200) {
        await _storeTokens(
          response.data['accessToken'],
          response.data['refreshToken'],
        );
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to login',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to login');
    }
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/me');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get user data',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to get user data');
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    final tokens = await getStoredTokens();
    if (tokens['refreshToken'] == null) {
      return false;
    }

    try {
      final response = await _dio.post(
        '/refresh',
        data: {
          'refreshToken': tokens['refreshToken'],
          'expiresInMins': 60,
        },
      );

      if (response.statusCode == 200) {
        await _storeTokens(
          response.data['accessToken'],
          response.data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final tokens = await getStoredTokens();
    return tokens['accessToken'] != null;
  }
}
