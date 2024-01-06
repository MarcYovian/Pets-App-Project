import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/common_widgets/my_button.dart';
import 'package:pets_shop/src/common_widgets/my_text_field.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/auth/application/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordConfirmed()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        // create user
        await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          nameController.text,
          numberController.text,
          addressController.text,
          int.parse(ageController.text),
        );

        Navigator.pushNamed(
          context,
          authGate,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error ${e.toString()}",
            ),
          ),
        );
      }
    }
  }

  bool passwordConfirmed() {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // check that the passwords do not match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password do not match!",
          ),
        ),
      );
      return false;
    }

    // Make sure the password doesn't meet the requirements
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must be at least 8 characters long and contain at least have upper case letters, lower case letters, and have numbers",
          ),
        ),
      );

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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

                  // create account message
                  const Text(
                    "Let's create account for you!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(25),

                  // name text field
                  MyTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(10),

                  // number text field
                  MyTextField(
                    controller: numberController,
                    hintText: "Phone Number",
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const Gap(10),

                  // age text field
                  MyTextField(
                    controller: ageController,
                    hintText: "Age",
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const Gap(10),

                  // email text field
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(10),

                  // email text field
                  MyTextField(
                    controller: addressController,
                    hintText: "Address",
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
                  const Gap(10),

                  // confirm password text field
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(15),

                  // sign up button
                  MyButton(
                    onTap: signUp,
                    text: "sign Up",
                  ),
                  const Gap(50),

                  // Already a member ? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member ?"),
                      const Gap(4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
