import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeService {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Get User Data
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    return _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  // Get Pets Data Without Current User
  Stream<QuerySnapshot> getAllPetsWithoutCurrentUser() {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    return _firebaseFirestore
        .collection('pets_data')
        .where('userUid', isNotEqualTo: currentUserId)
        .snapshots();
  }
}
