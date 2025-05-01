import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';
import 'package:sadeem_shop/Config/themes/theme.dart';
import 'package:sadeem_shop/core/services/auth_service.dart';
import 'package:sadeem_shop/features/auth/presentation/cubit/auth_state.dart';
import 'package:sadeem_shop/features/cart/data/repositories/cart_repository.dart';
import 'package:sadeem_shop/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:sadeem_shop/features/products/domain/repositories/products_repository.dart';
import 'package:sadeem_shop/features/products/presentation/cubit/products_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await setupServiceLocator();

  final authService = AuthService();
  final authCubit = AuthCubit(authService: authService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => authCubit..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(
            repository: getIt<ProductsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => CartCubit(
            getIt<CartRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sadeem Shop',
      theme: AppTheme.lightTheme,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
