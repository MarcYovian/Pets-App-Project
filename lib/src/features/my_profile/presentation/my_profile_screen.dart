import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/features/my_profile/data/my_profile_service.dart';
import 'package:pets_shop/src/features/my_profile/presentation/widget/detail_text_field.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

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
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {},
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.edit),
            ),
          ),
          const Gap(10),
        ],
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
              print(snapshot.data!.docs.first.data() as Map<String, dynamic>);
              ProfileModel profileData = ProfileModel.fromMap(
                  snapshot.data!.docs.first.data() as Map<String, dynamic>);
              // print(profileData.toMap());
              return Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            profileData.image,
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(70),

                  // Full Name
                  DetailTextField(
                    title: "Full Name",
                    value: profileData.fullName,
                  ),
                  const Gap(20),

                  // email
                  DetailTextField(
                    title: "Email",
                    value: profileData.email,
                  ),
                  const Gap(20),

                  // Phone Number
                  DetailTextField(
                    title: "Phone Number",
                    value: profileData.phoneNumber,
                  ),
                  const Gap(20),

                  // Age
                  DetailTextField(
                    title: "Age",
                    value: profileData.age.toString(),
                  ),
                  const Gap(20),

                  // address
                  DetailTextField(
                    title: "Address",
                    value: profileData.address,
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
