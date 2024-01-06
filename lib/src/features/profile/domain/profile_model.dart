// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int age;
  final String address;
  final String image;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  ProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.address,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  ProfileModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    int? age,
    String? address,
    String? image,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      address: address ?? this.address,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'address': address,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      age: map['age'] as int,
      address: map['address'] as String,
      image: map['image'] as String,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, age: $age, address: $address, image: $image, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.age == age &&
        other.address == address &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        age.hashCode ^
        address.hashCode ^
        image.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
