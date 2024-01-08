import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class PetDetails extends StatefulWidget {
  final String petId;
  final Pets pet;
  const PetDetails({super.key, required this.pet, required this.petId});

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PetsService _petsService = PetsService();
  bool isFavorite = false;

  Stream<DocumentSnapshot<Map<String, dynamic>>> _checkIsFavorite() {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('favorite_pet')
        .doc(widget.petId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firebaseFirestore
            .collection("users")
            .doc(widget.pet.userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          ProfileModel profile = ProfileModel.fromMap(
              snapshot.data!.data() as Map<String, dynamic>);
          return Column(
            children: [
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            widget.pet.imagePath,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 13,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            // color: Colors.amber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.chevron_left_outlined,
                                    size: 40,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: _petsService
                                      .checkIsFavorite(widget.petId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text("error");
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    return IconButton(
                                      onPressed: () {
                                        if (snapshot.data!.exists) {
                                          _petsService.removeFavoritePetData(
                                              widget.petId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Pet data was remove from favorites!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          _petsService.sendFavoritePetData(
                                              widget.petId, widget.pet);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Pet data was successfully add to favorites!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        snapshot.data!.exists
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Name n price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.pet.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              "Rp ${widget.pet.price.toString()}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const Gap(18),

                      // Age, Gender, Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SmallBox(
                            title: "Age",
                            value: widget.pet.age.toString(),
                          ),
                          SmallBox(
                            title: "Gender",
                            value: widget.pet.gender,
                          ),
                          SmallBox(
                            title: "Type",
                            value: widget.pet.category,
                          ),
                        ],
                      ),
                      const Gap(30),

                      // Owner
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 70),
                            padding: const EdgeInsets.only(left: 40),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              color: Colors.amber.shade100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  ),
                                ),
                                const Text(
                                  "Owner",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 45, top: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                profile.image,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Gap(20),

                      // Description
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Text(
                          widget.pet.description,
                          textAlign: TextAlign.left,
                          softWrap: true,
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            chatScreen,
                            arguments: {
                              'receivedUserEmail': profile.email,
                              'receiverUserId': widget.pet.userUid,
                            },
                          );
                        },
                        child: const Icon(
                          Icons.chat,
                          color: Colors.pink,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            checkoutScreen,
                            arguments: {
                              'petId': widget.petId,
                              'pet': widget.pet,
                              'profile': profile,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.pink,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.pets,
                                color: Colors.white,
                              ),
                              Gap(5),
                              Text(
                                "Adoption",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SmallBox extends StatelessWidget {
  final String title;
  final String value;
  const SmallBox({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Age",
            style: TextStyle(
              color: Colors.pink.shade300,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
