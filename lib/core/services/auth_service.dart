import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/entities/user.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokens = await getStoredTokens();
          if (tokens['accessToken'] != null) {
            options.headers['Authorization'] =
                'Bearer ${tokens['accessToken']}';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await refreshToken();
            if (refreshed) {
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

        debugPrint('Login shared init');
        SharedPreferences? prefs;
        try {
          WidgetsFlutterBinding.ensureInitialized();
          prefs = await SharedPreferences.getInstance();
          debugPrint('Login shared init success');
          //I don't know why it's not works🥲
          if (prefs != null) {
            await prefs.setString('user_data', json.encode(response.data));
            debugPrint('User data successfully');
          } else {
            debugPrint('instance is null');
          }
        } catch (e) {
          debugPrint('SharedPreferences error: $e');
          debugPrint(e.toString());
        }

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

  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<Map<String, String?>> getStoredTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

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

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final tokens = await getStoredTokens();
    return tokens['accessToken'] != null;
  }

  Future<User> getStoredUser() async {
    try {
      SharedPreferences? prefs;
      try {
        prefs = await SharedPreferences.getInstance();
      } catch (e) {
        debugPrint('Failed to initialize SharedPreferences: $e');
        throw Exception('Failed to initialize storage');
      }

      final userJson = prefs.getString('user_data');
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
      throw Exception('No stored user data found');
    } catch (e) {
      throw Exception('Failed to get stored user: $e');
    }
  }
}
