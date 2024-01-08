import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_shop/src/features/checkout/domain/checkout.dart';

class CheckoutService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendCheckoutData(Checkout checkout) async {
    await _firestore.collection("checkout").add(checkout.toMap());
  }

  Future<void> deletePetFromDatabase(String petId) async {
    await _firestore.collection("pets_data").doc(petId).delete();
  }
}
