import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class MyProfileService {
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

  // Update Profile data
  Future<void> updateProfile(String uid, ProfileModel profileModel) async {
    await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .update(profileModel.toMap());
  }
}
