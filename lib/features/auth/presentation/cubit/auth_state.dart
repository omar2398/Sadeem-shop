import 'package:equatable/equatable.dart';
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
  final bool isNewLogin;

  const AuthSuccess({
    required this.tokens,
    this.isNewLogin = false,
  });

  @override
  List<Object?> get props => [tokens, isNewLogin];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
