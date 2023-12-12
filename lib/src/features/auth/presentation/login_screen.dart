import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/common_widgets/my_button.dart';
import 'package:pets_shop/src/common_widgets/my_text_field.dart';
import 'package:pets_shop/src/features/auth/application/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(50),

                  // Logo
                  Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.grey[800],
                  ),
                  const Gap(25),

                  // Welcome back message
                  const Text(
                    "Welcome back you've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(25),

                  // email text field
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(10),

                  // password text field
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(15),

                  // sign in button
                  MyButton(
                    onTap: signIn,
                    text: "Sign In",
                  ),
                  const Gap(50),

                  // not a member ? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("not a member ?"),
                      const Gap(4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
