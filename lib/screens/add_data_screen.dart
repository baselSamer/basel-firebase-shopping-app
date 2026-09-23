import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Phase 2 requirement: an input form with Name, Age, and Favourite
/// Hobby fields, a "Save" button that writes to Firestore, and a
/// "View Saved Data" button that opens the display page.
class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _hobbyController = TextEditingController();
  final _firestoreService = FirestoreService();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _hobbyController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Writes the three form fields to the "user_data" Firestore collection.
    await _firestoreService.addUserData(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      favouriteHobby: _hobbyController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    _nameController.clear();
    _ageController.clear();
    _hobbyController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved to Firestore!')));
  }

  void _goToDisplayScreen() {
    Navigator.of(context).pushNamed('/display-data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your Data')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              CustomTextField(
                controller: _ageController,
                labelText: 'Age',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Age must be a whole number';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _hobbyController,
                labelText: 'Favourite Hobby',
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a hobby'
                    : null,
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Save',
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'View Saved Data',
                isOutlined: true,
                onPressed: _goToDisplayScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
