import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/common_widgets/my_button.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

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
      // appBar: AppBar(
      //   actions: [
      //     StreamBuilder(
      //       stream: _petsService.checkIsFavorite(widget.petId),
      //       builder: (context, snapshot) {
      // if (snapshot.hasError) {
      //   return const Text("error");
      // }

      // if (snapshot.connectionState == ConnectionState.waiting) {
      //   return const CircularProgressIndicator();
      // }

      //         return IconButton(
      //           onPressed: () {
      // if (snapshot.data!.exists) {
      //   _petsService.removeFavoritePetData(widget.petId);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Pet data was remove from favorites!'),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // } else {
      //   _petsService.sendFavoritePetData(widget.petId, widget.pet);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content:
      //           Text('Pet data was successfully add to favorites!'),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // }
      //           },
      //           icon: Icon(
      // snapshot.data!.exists
      //     ? Icons.favorite
      //     : Icons.favorite_border,
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                            print("Tes");
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.chevron_left_outlined,
                            size: 40,
                          ),
                        ),
                        StreamBuilder(
                          stream: _petsService.checkIsFavorite(widget.petId),
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
                                  _petsService
                                      .removeFavoritePetData(widget.petId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Pet data was remove from favorites!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  _petsService.sendFavoritePetData(
                                      widget.petId, widget.pet);
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Gap(18),
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
              StreamBuilder(
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

                  var data = snapshot.data!.data();

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        padding: const EdgeInsets.only(left: 60),
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
                              data!['fullName'].toString(),
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
                        padding: const EdgeInsets.only(left: 25, top: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            data['image'],
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet est ac elit gravida sollicitudin. Aenean vestibulum, augue quis malesuada eleifend, leo risus iaculis ligula, sed imperdiet leo felis non est. Duis convallis enim nec nisi malesuada, eu gravida lacus pulvinar. Proin ut bibendum turpis. Pellentesque congue quam nibh, at molestie dolor pretium id. Aenean quis mauris sed lorem cursus bibendum. Aliquam pretium aliquet ipsum, a aliquet ipsum vulputate eget. Phasellus nec massa non turpis semper scelerisque at sed leo. Praesent ac nulla ut lectus sagittis luctus. Suspendisse dapibus diam at risus aliquam, feugiat iaculis turpis ultricies. Quisque elit turpis, commodo at lorem at, dignissim pretium turpis.",
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
              const Gap(20),

              // CTA Button
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9,
                padding: const EdgeInsets.all(10),
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(Icons.chat, color: Colors.amber),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.pink,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.pets,
                              color: Colors.white,
                            ),
                            Text(
                              "Adoption",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
