// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/auth/application/auth_service.dart';
import 'package:pets_shop/src/features/profile/data/profile_service.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';
import 'package:pets_shop/src/features/profile/presentation/widget/option_menu.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Center(
          child: Text("Profile"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            // color: Colors.amber,
            child: StreamBuilder<QuerySnapshot>(
              stream: ProfileService().getProfileData(
                _firebaseAuth.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                ProfileModel profile = ProfileModel.fromMap(
                    snapshot.data!.docs.first.data() as Map<String, dynamic>);

                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        profile.image,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Gap(15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          profile.email,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // My Profile
                    OptionMenu(
                      onTap: () {
                        Navigator.pushNamed(context, myProfileScreen);
                      },
                      iconData: Icons.person,
                      menuName: "My Profile",
                    ),
                    const Gap(10),

                    // Settings
                    OptionMenu(
                      onTap: () {},
                      iconData: Icons.settings,
                      menuName: "Settings",
                    ),
                    const Gap(10),

                    // Notifications
                    OptionMenu(
                      onTap: () {},
                      iconData: Icons.notifications,
                      menuName: "Notifications",
                    ),
                    const Gap(10),

                    // My Pets
                    OptionMenu(
                      onTap: () {
                        Navigator.pushNamed(context, myPetsScreen);
                      },
                      iconData: Icons.pets,
                      menuName: "My Pets",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),

          // Logout
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: OptionMenu(
              onTap: () async {
                if (!mounted) return;
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                await authService.signOut();
                Navigator.pushNamed(context, authGate);
              },
              iconData: Icons.logout_rounded,
              menuName: "Logout",
            ),
          ),
        ],
      ),
    );
  }
}
