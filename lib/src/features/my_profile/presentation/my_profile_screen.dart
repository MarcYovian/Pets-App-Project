import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/features/my_profile/data/my_profile_service.dart';
import 'package:pets_shop/src/features/my_profile/presentation/widget/detail_text_field.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("My Profile"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: MyProfileService()
                .getProfileData(_firebaseAuth.currentUser!.uid),
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
              Map<String, dynamic> profileData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;

              return Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        profileData['image'],
                        height: 120,
                        width: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Gap(70),

                  // Full Name
                  DetailTextField(
                    title: "Full Name",
                    value: profileData['full name'] ?? "",
                  ),
                  const Gap(20),

                  // email
                  DetailTextField(
                    title: "Email",
                    value: profileData['email'] ?? "",
                  ),
                  const Gap(20),

                  // Phone Number
                  DetailTextField(
                    title: "Phone Number",
                    value: profileData['phone number'] ?? "",
                  ),
                  const Gap(20),

                  // Age
                  DetailTextField(
                    title: "Age",
                    value: profileData['age'],
                  ),
                  const Gap(20),

                  // address
                  DetailTextField(
                    title: "Address",
                    value: profileData['address'] ?? "",
                  ),
                  const Gap(20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
