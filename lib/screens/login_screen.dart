import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Phase 1 requirement: a login page with an Email field, a Password
/// field, a "Sign In" button that goes to Home on success, and a
/// "Create Account" button that goes to the Sign Up page.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Delegates the actual Firebase Authentication call to AuthService.
    final error = await _authService.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error == null) {
      // Sign-in succeeded: go to Home and clear the login page from
      // the back stack so the back button doesn't return to it.
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else {
      setState(() => _errorMessage = error);
    }
  }

  void _goToSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.shopping_bag, size: 64, color: Colors.indigo),
              const SizedBox(height: 24),
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
                label: 'Sign In',
                isLoading: _isSubmitting,
                onPressed: _handleSignIn,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Create an Account',
                isOutlined: true,
                onPressed: _goToSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
