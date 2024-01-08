import 'package:flutter/material.dart';
import 'package:pets_shop/src/common_widgets/my_bottom_navbar.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/auth/application/auth_gate.dart';
import 'package:pets_shop/src/features/auth/application/loginOrRegister.dart';
import 'package:pets_shop/src/features/auth/presentation/welcome_screen.dart';
import 'package:pets_shop/src/features/chat/domain/chat_model.dart';
import 'package:pets_shop/src/features/chat/presentation/chat_list_screen.dart';
import 'package:pets_shop/src/features/chat/presentation/chat_screen.dart';
import 'package:pets_shop/src/features/home/presentation/home_screen.dart';
import 'package:pets_shop/src/features/my_profile/presentation/my_profile_screen.dart';
import 'package:pets_shop/src/features/pets/presentation/create_pets_screen.dart';
import 'package:pets_shop/src/features/pets/presentation/favorite_pets.dart';
import 'package:pets_shop/src/features/pets/presentation/widget/my_pets.dart';
import 'package:pets_shop/src/features/profile/presentation/profile_screen.dart';

class MyRoutes {
  static List pages = [
    const HomeScreen(),
    const FavoritePets(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  static Route<dynamic> generateRoute(RouteSettings setting) {
    final arg = setting.arguments as Map<String, dynamic>?;
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
      case bottomNavScreen:
        return MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(
            index: arg!['index'],
          ),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => const AuthGate(),
        );
      case chatScreen:
        return MaterialPageRoute(
          builder: (context) => ChatScreen(
            receivedUserEmail: arg!['receivedUserEmail'],
            receiverUserId: arg['receiverUserId'],
          ),
        );
      case myPetsScreen:
        return MaterialPageRoute(
          builder: (context) => const MyPets(),
        );
      case addPetsScreen:
        return MaterialPageRoute(
          builder: (context) => const CreatePetsScreen(),
        );
      case myProfileScreen:
        return MaterialPageRoute(
          builder: (context) => const MyProfileScreen(),
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
