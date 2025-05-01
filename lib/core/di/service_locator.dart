import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:sadeem_shop/core/services/auth_service.dart';
import 'package:sadeem_shop/features/cart/data/repositories/cart_repository.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/products/data/datasources/products_remote_datasource.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  getIt.registerLazySingleton(() => Dio());

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
        remoteDataSource: getIt<ProductsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(dio: getIt<Dio>()),
  );
  // Use cases
  getIt.registerLazySingleton(
      () => LoginUseCase(repository: getIt<AuthRepository>()));

  // Cubits
  getIt.registerFactory(() => AuthCubit(
        authService: getIt<AuthService>(),
      ));
  // Services
  getIt.registerLazySingleton(() => AuthService());
}
