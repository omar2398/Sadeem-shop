import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sadeem_shop/features/auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(username: username, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(message: 'Authentication failed')),
      (tokens) => emit(AuthSuccess(tokens: tokens)),
    );
  }
}
