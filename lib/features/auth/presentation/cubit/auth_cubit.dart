import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/features/auth/domain/entities/user.dart';
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
        final userData =
            await _authService.getStoredUser(); // Get stored user data
        emit(AuthSuccess(
          tokens: AuthTokens(
            accessToken: tokens['accessToken']!,
            refreshToken: tokens['refreshToken']!,
          ),
          user: userData, // Add the user parameter
          isNewLogin: false,
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

      final user = User.fromJson(response);
      final tokens = AuthTokens(
        accessToken: response['accessToken'],
        refreshToken: response['refreshToken'],
      );

      emit(AuthSuccess(
        tokens: tokens,
        user: user,
        isNewLogin: true,
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
