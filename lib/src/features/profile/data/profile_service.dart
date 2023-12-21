import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  // get instance firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Get Profile data
  Stream<QuerySnapshot> getProfileData(String uid) {
    final currentProfile = _firebaseFirestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots();

    return currentProfile;
  }
}
