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

  // Future<List<Pets>> getAllPetsByCurrentUser() async {
  //   final String currentUserId = _firebaseAuth.currentUser!.uid;
  //   // Query to get all pets of the current user
  //   QuerySnapshot querySnapshot = await _firebaseFirestore
  //       .collection('users')
  //       .doc(currentUserId)
  //       .collection('pets')
  //       .get();

  //   List<Pets> petsList = [];

  //   for (var doc in querySnapshot.docs) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  //     DocumentSnapshot<Map<String, dynamic>> petDataSnapshot =
  //         await _firebaseFirestore
  //             .collection('pets_data')
  //             .doc(data['uid pet'])
  //             .get();
  //     Pets pet = Pets.fromMap(petDataSnapshot.data() as Map<String, dynamic>);
  //     petsList.add(pet);
  //   }

  //   return petsList;
  // }
}
