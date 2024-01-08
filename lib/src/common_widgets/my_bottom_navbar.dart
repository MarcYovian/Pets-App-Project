// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:pets_shop/src/routing/my_routes.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int? index;
  const MyBottomNavigationBar({
    Key? key,
    this.index,
  }) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    bottomNavIndex();
    super.initState();
  }

  bottomNavIndex() {
    if (widget.index != null) {
      setState(() {
        selectedIndex = widget.index!;
      });
    }
  }

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
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.black,
        items: [
          // home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.amber,
            unselectedColor: Colors.white,
          ),

          // home
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("Favorites"),
            selectedColor: Colors.amber,
            unselectedColor: Colors.white,
          ),

          // chat
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat),
            title: const Text("Chat"),
            selectedColor: Colors.amber,
            unselectedColor: Colors.white,
          ),

          // profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.amber,
            unselectedColor: Colors.white,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }
}
