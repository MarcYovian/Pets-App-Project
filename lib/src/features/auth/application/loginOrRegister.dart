// ignore: file_names
import 'package:flutter/material.dart';
import 'package:pets_shop/src/features/auth/presentation/login_screen.dart';
import 'package:pets_shop/src/features/auth/presentation/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  final bool isLoginPage;
  const LoginOrRegister({super.key, required this.isLoginPage});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show the login screen
  bool? showLoginScreen;

  @override
  void initState() {
    super.initState();
    showLoginScreen = widget.isLoginPage;
  }

  // toggle between login and register screen
  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen!) {
      return LoginScreen(
        onTap: toggleScreen,
      );
    } else {
      return RegisterScreen(
        onTap: toggleScreen,
      );
    }
  }
}
