import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

class HomeService {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Get User Data
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
  }

  // Get Pets Data Without Current User
  Future<Map<String, List<Object>>> getAllPetsWithoutCurrentUser() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    var data = await _firebaseFirestore
        .collection('pets_data')
        .where('userUid', isNotEqualTo: currentUserId)
        .get();

    List<String> listId = data.docs.map((e) => e.id).toList();
    List<Pets> listPets = data.docs.map((e) => Pets.fromMap(e.data())).toList();

    return {
      "id": listId,
      "data": listPets,
    };
  }
}
