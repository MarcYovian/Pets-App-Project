import 'package:cloud_firestore/cloud_firestore.dart';

class Pets {
  String? userUid;
  String? name;
  String? category;
  String? description;
  int? age;
  String? gender;
  double? price;
  String? imagePath;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Pets({
    this.userUid,
    this.name,
    this.category,
    this.description,
    this.age,
    this.gender,
    this.price,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
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

  static Pets fromMap(Map<String, dynamic> map) {
    return Pets(
      userUid: map['userUid'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      age: map['age'],
      gender: map['gender'],
      price: map['price'],
      imagePath: map['imagePath'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
