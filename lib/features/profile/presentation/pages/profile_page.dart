import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadeem_shop/core/widgets/custom_snackbar.dart';
import 'package:sadeem_shop/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sadeem_shop/features/auth/presentation/cubit/auth_state.dart';
import 'package:sadeem_shop/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.image),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSettingItem(
                        icon: Icons.person_outline,
                        iconColor: Colors.blue,
                        title: 'Name',
                        value: '${user.firstName} ${user.lastName}',
                        onTap: () {},
                        showArrow: false),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.email,
                      iconColor: Colors.blue,
                      title: 'Email',
                      value: user.email,
                      showArrow: false,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.family_restroom,
                      iconColor: Colors.blue,
                      title: 'Gender',
                      value: user.gender,
                      showArrow: false,
                      onTap: () {
                        CustomSnackBar.show(
                            context: context,
                            message: "This feature isn't available now!!",
                            isSuccess: false);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.language_outlined,
                      iconColor: Colors.blue,
                      title: 'Language',
                      value: 'English',
                      onTap: () {
                        CustomSnackBar.show(
                            context: context,
                            message: "This feature isn't available now!!",
                            isSuccess: false);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.dark_mode_outlined,
                      iconColor: Colors.blue,
                      title: 'Dark mode',
                      isSwitch: true,
                      onTap: () {
                        CustomSnackBar.show(
                            context: context,
                            message: "This feature isn't available now!!",
                            isSuccess: false);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      title: 'Logout',
                      showArrow: false,
                      onTap: () {
                        context.read<AuthCubit>().logout().then(
                              (_) => Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? value,
    bool showArrow = true,
    bool isSwitch = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isSwitch
            ? Switch(
                value: false,
                onChanged: (value) {},
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value != null)
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  if (showArrow)
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                ],
              ),
        onTap: onTap,
      ),
    );
  }
}
