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

  const AuthSuccess({required this.tokens});

  @override
  List<Object?> get props => [tokens];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
