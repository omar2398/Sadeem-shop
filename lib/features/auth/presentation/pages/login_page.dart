import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/core/di/service_locator.dart';
import 'package:sadeem_shop/core/widgets/custom_form_field.dart';
import 'package:sadeem_shop/features/auth/presentation/cubit/auth_state.dart';
import 'package:sadeem_shop/features/home/presentation/pages/home_page.dart';
import 'package:sadeem_shop/features/products/domain/repositories/products_repository.dart';
import 'package:sadeem_shop/features/products/presentation/cubit/products_cubit.dart';
import 'package:sadeem_shop/features/products/presentation/pages/products_page.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../cubit/auth_cubit.dart';
import '../constants/auth_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.primary,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess && state.isNewLogin) {
            CustomSnackBar.show(
              context: context,
              message: AuthTexts.loginSuccessMessage,
              isSuccess: true,
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (state is AuthError) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/Shopping App Vector.png',
                            width: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Center(
                            child: Text(
                              AuthTexts.loginTitle,
                              style: TextStyle(
                                color: AuthColors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AuthColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AuthTexts.welcomeBack,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            AuthTexts.welcomeDescription,
                            style: TextStyle(
                              fontSize: 16,
                              color: AuthColors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          CustomFormField(
                            controller: _emailController,
                            label: AuthTexts.usernameLabel,
                            hintText: AuthTexts.emailHint,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AuthTexts.emailValidationMessage;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomFormField(
                            controller: _passwordController,
                            label: AuthTexts.passwordLabel,
                            hintText: AuthTexts.passwordHint,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AuthTexts.passwordValidationMessage;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Text(AuthTexts.rememberMe),
                            ],
                          ),
                          const SizedBox(height: 150),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        context.read<AuthCubit>().login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AuthColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      color: AuthColors.white)
                                  : const Text(
                                      AuthTexts.loginButton,
                                      style: TextStyle(
                                        color: AuthColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
