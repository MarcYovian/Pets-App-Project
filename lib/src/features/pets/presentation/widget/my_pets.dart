import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/common_widgets/my_card.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

class MyPets extends StatefulWidget {
  const MyPets({super.key});

  @override
  State<MyPets> createState() => _MyPetsState();
}

class _MyPetsState extends State<MyPets> {
  final PetsService _petsService = PetsService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("My Pets"),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              bottomNavScreen,
              arguments: {
                'index': 3,
              },
            );
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, addPetsScreen);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // height: ,
                width: MediaQuery.of(context).size.width,
                // color: Colors.blue,
                child: StreamBuilder(
                  stream: _petsService.getAllPetsByCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Error: ${snapshot.error}",
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Waiting");
                    }

                    return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs
                          .map((document) => _buildPetDataItem(document))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDataItem(DocumentSnapshot document) {
    Pets pet = Pets.fromMap(document.data() as Map<String, dynamic>);

    return GestureDetector(
      onTap: () {},
      child: MyCard(
        pet: pet,
      ),
    );
  }
}
