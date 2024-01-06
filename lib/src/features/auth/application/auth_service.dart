import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in;
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String phoneNumber,
    String address,
    int age,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ProfileModel profile = ProfileModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        age: age,
        address: address,
        image:
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      // create a new document for the user in the user collection
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(profile.toMap());
      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Sign user in
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
