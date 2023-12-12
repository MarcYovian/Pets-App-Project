import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/auth/presentation/widget/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // intro pets shop
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.only(top: 75),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/1.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        "Adopt a Pet, Save Their Life",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 1,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],
                        ),
                      ),
                      Gap(10),
                      Text(
                        "Lorem ipsum dolor sit amet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 1,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // navigation buttons to login or register
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // My Button for Login
                  MyButton(
                      onTap: () {
                        Navigator.pushNamed(context, authGate);
                      },
                      text: "Login"),

                  // My Button for Register
                  MyButton(
                      onTap: () {
                        Navigator.pushNamed(context, registerScreen);
                      },
                      text: "Register"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
