import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Registration page for users who don't have an account yet.
/// Reuses the same CustomTextField/CustomButton widgets as LoginScreen
/// to avoid duplicating form styling code.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Creates a new Firebase Authentication user with email/password.
    final error = await _authService.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error == null) {
      // New account is created and automatically signed in by Firebase,
      // so go straight to Home.
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else {
      setState(() => _errorMessage = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) => (value == null || value.length < 6)
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              CustomButton(
                label: 'Sign Up',
                isLoading: _isSubmitting,
                onPressed: _handleSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
