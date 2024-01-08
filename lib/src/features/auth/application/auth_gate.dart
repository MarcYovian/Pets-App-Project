import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/common_widgets/my_bottom_navbar.dart';
import 'package:pets_shop/src/features/auth/application/loginOrRegister.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MyBottomNavigationBar();
          }

          // user in NOT logged in
          else {
            return const LoginOrRegister(isLoginPage: true);
          }
        },
      ),
    );
  }
}
