import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

class PetsService {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send Pets Data
  Future<void> sendPetsData(
    String name,
    String category,
    String description,
    int age,
    String gender,
    double price,
    String imagePath,
  ) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp createdAt = Timestamp.now();
    final Timestamp updatedAt = Timestamp.now();

    // create a new pet
    Pets pet = Pets(
      userUid: currentUserId,
      name: name,
      category: category,
      description: description,
      age: age,
      gender: gender,
      price: price,
      imagePath: imagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    // add a new pet data to database
    await _firebaseFirestore.collection("pets_data").add(pet.toMap());
  }

  // get all pets id by current user
  Stream<QuerySnapshot> getAllPetsByCurrentUser() {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    // get all pet uid from current user
    return _firebaseFirestore
        .collection('pets_data')
        .where('userUid', isEqualTo: currentUserId)
        .orderBy('updatedAt', descending: false)
        .snapshots();
  }

  // get pet data by id
  Stream<DocumentSnapshot<Map<String, dynamic>>> getPetDataById(String petId) {
    return _firebaseFirestore.collection('pets_data').doc(petId).snapshots();
  }

  // Send Favorite pet data
  Future<void> sendFavoritePetData(String petId, Pets pet) async {
    var currentUid = _firebaseAuth.currentUser!.uid;

    // send data to database
    await _firebaseFirestore
        .collection('users')
        .doc(currentUid)
        .collection('favorite_pet')
        .doc(petId)
        .set(pet.toMap());
  }

  Future<void> removeFavoritePetData(String petId) async {
    var currentUid = _firebaseAuth.currentUser!.uid;

    await _firebaseFirestore
        .collection('users')
        .doc(currentUid)
        .collection('favorite_pet')
        .doc(petId)
        .delete();
  }

  // get favorite pet data
  Future<QuerySnapshot> getFavoritePetData() {
    var currentUid = _firebaseAuth.currentUser!.uid;

    return _firebaseFirestore
        .collection('users')
        .doc(currentUid)
        .collection('favorite_pet')
        .get();
  }
}
