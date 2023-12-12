import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/routing/my_routes.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;

  final pages = MyRoutes.pages;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAtOrNull(selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade300,
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(Icons.home),
          Icon(Icons.favorite),
          Icon(Icons.add),
          Icon(Icons.chat),
          Icon(Icons.person),
        ],
        onTap: onTap,
        index: selectedIndex,
      ),
    );
  }
}
