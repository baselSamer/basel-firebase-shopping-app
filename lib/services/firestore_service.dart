import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_data_model.dart';

/// Wraps all Cloud Firestore reads/writes for the "user_data" collection
/// so screens never call FirebaseFirestore directly.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Name of the Firestore collection that stores form submissions.
  static const String _collectionName = 'user_data';

  /// Saves one form submission (Name, Age, Favourite Hobby) to Firestore,
  /// tagged with the id of whoever is currently signed in.
  Future<void> addUserData({
    required String name,
    required int age,
    required String favouriteHobby,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    final record = UserDataModel(
      ownerUserId: currentUserId,
      name: name,
      age: age,
      favouriteHobby: favouriteHobby,
    );

    await _firestore.collection(_collectionName).add(record.toMap());
  }

  /// A live stream of every saved record, newest first. The display
  /// screen listens to this so the list updates automatically whenever
  /// Firestore data changes.
  Stream<List<UserDataModel>> streamAllUserData() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(UserDataModel.fromDocument).toList(),
        );
  }
}
