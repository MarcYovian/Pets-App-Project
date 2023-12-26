import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        actions: [
          StreamBuilder(
            stream: _checkIsFavorite(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("error");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return IconButton(
                onPressed: () {
                  if (snapshot.data!.exists) {
                    _petsService.removeFavoritePetData(widget.petId);
                  } else {
                    _petsService.sendFavoritePetData(widget.petId, widget.pet);
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Image.network(
                  widget.pet.imagePath!,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendFavoritePet(BuildContext context) async {
    try {
      await _petsService.sendFavoritePetData(widget.petId, widget.pet);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet data was successfully added to favorites!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding pet data to favorites.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
