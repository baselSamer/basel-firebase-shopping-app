import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../models/user_data_model.dart';

/// Phase 2 requirement: a display page that reads and shows every
/// record saved from AddDataScreen. Uses a StreamBuilder so the list
/// updates live whenever Firestore data changes.
class DisplayDataScreen extends StatelessWidget {
  const DisplayDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Data')),
      body: StreamBuilder<List<UserDataModel>>(
        // Listens to the "user_data" collection in real time.
        stream: firestoreService.streamAllUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No records saved yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.indigo),
                  title: Text(record.name),
                  subtitle: Text(
                    'Age: ${record.age}  •  Hobby: ${record.favouriteHobby}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
