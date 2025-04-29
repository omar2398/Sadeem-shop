import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/auth_tokens.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      emit(AuthLoading());
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final tokens = await _authService.getStoredTokens();
        emit(AuthSuccess(
          tokens: AuthTokens(
            accessToken: tokens['accessToken']!,
            refreshToken: tokens['refreshToken']!,
          ),
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    try {
      emit(AuthLoading());
      final response = await _authService.login(username, password);
      emit(AuthSuccess(
        tokens: AuthTokens(
          accessToken: response['accessToken'],
          refreshToken: response['refreshToken'],
        ),
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
