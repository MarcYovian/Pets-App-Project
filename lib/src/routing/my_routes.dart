import 'package:flutter/material.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/auth/application/auth_gate.dart';
import 'package:pets_shop/src/features/auth/application/loginOrRegister.dart';
import 'package:pets_shop/src/features/auth/presentation/welcome_screen.dart';
import 'package:pets_shop/src/features/home/presentation/home_screen.dart';

class MyRoutes {
  static List pages = [
    const HomeScreen(),
    const Center(child: Text("Page 2")),
    const Center(child: Text("Page 3")),
    const Center(child: Text("Page 4")),
    const Center(child: Text("Page 5")),
  ];

  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case welcomeScreen:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      case authGate:
        return MaterialPageRoute(
          builder: (context) => const AuthGate(),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginOrRegister(isLoginPage: true),
        );
      case registerScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginOrRegister(isLoginPage: false),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => const AuthGate(),
        );
      default:
    }
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text("no route defined"),
        ),
      ),
    );
  }
}
