// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  void _sendResetLink() {
    final email = _emailController.text;
    // Add logic to send reset link
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter your email to receive a password reset link.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomTextField(controller: _emailController, hintText: 'Email'),
            const SizedBox(height: 32),
            CustomButton(onPressed: _sendResetLink, text: 'Send Reset Link'),
          ],
        ),
      ),
    );
  }
}
