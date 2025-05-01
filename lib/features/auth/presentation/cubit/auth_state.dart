import 'package:equatable/equatable.dart';
import 'package:sadeem_shop/features/auth/domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthTokens tokens;
  final User user;
  final bool isNewLogin;

  const AuthSuccess({
    required this.tokens,
    required this.user,
    required this.isNewLogin,
  });
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
