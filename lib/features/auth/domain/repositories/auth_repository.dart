import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(String username, String password);
  Future<Either<Failure, User>> getCurrentUser(String token);
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken);
}
