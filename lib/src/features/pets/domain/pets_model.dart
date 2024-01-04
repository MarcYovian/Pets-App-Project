// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pets {
  final String userUid;
  final String name;
  final String category;
  final String description;
  final int age;
  final String gender;
  final double price;
  final String imagePath;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  Pets({
    required this.userUid,
    required this.name,
    required this.category,
    required this.description,
    required this.age,
    required this.gender,
    required this.price,
    required this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  Pets copyWith({
    String? userUid,
    String? name,
    String? category,
    String? description,
    int? age,
    String? gender,
    double? price,
    String? imagePath,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Pets(
      userUid: userUid ?? this.userUid,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userUid': userUid,
      'name': name,
      'category': category,
      'description': description,
      'age': age,
      'gender': gender,
      'price': price,
      'imagePath': imagePath,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Pets.fromMap(Map<String, dynamic> map) {
    return Pets(
      userUid: map['userUid'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      price: map['price'] as double,
      imagePath: map['imagePath'] as String,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Pets.fromJson(String source) =>
      Pets.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pets(userUid: $userUid, name: $name, category: $category, description: $description, age: $age, gender: $gender, price: $price, imagePath: $imagePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Pets other) {
    if (identical(this, other)) return true;

    return other.userUid == userUid &&
        other.name == name &&
        other.category == category &&
        other.description == description &&
        other.age == age &&
        other.gender == gender &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return userUid.hashCode ^
        name.hashCode ^
        category.hashCode ^
        description.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
