// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Checkout {
  final String petId;
  final String buyerUid;
  final String sellerUid;
  final String name;
  final String category;
  final String description;
  final int age;
  final String gender;
  final double price;
  final String imagePath;
  final String status;
  Timestamp? buyTime;
  Checkout({
    required this.petId,
    required this.buyerUid,
    required this.sellerUid,
    required this.name,
    required this.category,
    required this.description,
    required this.age,
    required this.gender,
    required this.price,
    required this.imagePath,
    required this.status,
    this.buyTime,
  });

  Checkout copyWith({
    String? petId,
    String? buyerUid,
    String? sellerUid,
    String? name,
    String? category,
    String? description,
    int? age,
    String? gender,
    double? price,
    String? imagePath,
    String? status,
    Timestamp? buyTime,
  }) {
    return Checkout(
      petId: petId ?? this.petId,
      buyerUid: buyerUid ?? this.buyerUid,
      sellerUid: sellerUid ?? this.sellerUid,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      buyTime: buyTime ?? this.buyTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'petId': petId,
      'buyerUid': buyerUid,
      'sellerUid': sellerUid,
      'name': name,
      'category': category,
      'description': description,
      'age': age,
      'gender': gender,
      'price': price,
      'imagePath': imagePath,
      'status': status,
      'buyTime': buyTime,
    };
  }

  factory Checkout.fromMap(Map<String, dynamic> map) {
    return Checkout(
      petId: map['petId'] as String,
      buyerUid: map['buyerUid'] as String,
      sellerUid: map['sellerUid'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      price: map['price'] as double,
      imagePath: map['imagePath'] as String,
      status: map['status'] as String,
      buyTime: map['buyTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Checkout.fromJson(String source) =>
      Checkout.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Checkout(petId: $petId, buyerUid: $buyerUid, sellerUid: $sellerUid, name: $name, category: $category, description: $description, age: $age, gender: $gender, price: $price, imagePath: $imagePath, status: $status, buyTime: $buyTime)';
  }

  @override
  bool operator ==(covariant Checkout other) {
    if (identical(this, other)) return true;

    return other.petId == petId &&
        other.buyerUid == buyerUid &&
        other.sellerUid == sellerUid &&
        other.name == name &&
        other.category == category &&
        other.description == description &&
        other.age == age &&
        other.gender == gender &&
        other.price == price &&
        other.imagePath == imagePath &&
        other.status == status &&
        other.buyTime == buyTime;
  }

  @override
  int get hashCode {
    return petId.hashCode ^
        buyerUid.hashCode ^
        sellerUid.hashCode ^
        name.hashCode ^
        category.hashCode ^
        description.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        price.hashCode ^
        imagePath.hashCode ^
        status.hashCode ^
        buyTime.hashCode;
  }
}
