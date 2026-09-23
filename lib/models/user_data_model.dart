import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents one record saved from the input form (Phase 2):
/// a name, an age, and a favourite hobby, tagged with the id of the
/// signed-in user who created it and a server-side timestamp.
class UserDataModel {
  final String? id;
  final String ownerUserId;
  final String name;
  final int age;
  final String favouriteHobby;
  final Timestamp? createdAt;

  UserDataModel({
    this.id,
    required this.ownerUserId,
    required this.name,
    required this.age,
    required this.favouriteHobby,
    this.createdAt,
  });

  /// Converts this record into a map for writing to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'ownerUserId': ownerUserId,
      'name': name,
      'age': age,
      'favouriteHobby': favouriteHobby,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Builds a record from a Firestore document snapshot.
  factory UserDataModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserDataModel(
      id: doc.id,
      ownerUserId: data['ownerUserId'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      favouriteHobby: data['favouriteHobby'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
