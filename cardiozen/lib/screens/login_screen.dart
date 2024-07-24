// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
  setState(() {
    _isLoading = true;
  });

  final email = _emailController.text;
  final password = _passwordController.text;

  final url = Uri.parse('http://192.168.0.129:8000/api/auth/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    setState(() {
      _isLoading = false;
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response headers: ${response.headers}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is Map) {
        final token = responseBody['token'];
        if (token != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed: No token found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: Invalid response format')),
        );
      }
    } else {
      // Handle non-200 status codes
      String errorMessage = 'Unknown error';
      try {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map) {
          errorMessage = responseBody['message'] ?? 'Unknown error';
        } else if (responseBody is String) {
          errorMessage = responseBody; // If response is a plain string
        }
      } catch (e) {
        errorMessage = 'Invalid response format';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $errorMessage')),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            _buildHeader(),
            const SizedBox(height: 50),
            CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true),
            const SizedBox(height: 8),
            _buildForgotPassword(context),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : CustomButton(onPressed: _login, text: 'Login'),
            const SizedBox(height: 20),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'CardioZen',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back! Please login to your account.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(fontSize: 14, color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegistrationScreen()),
            );
          },
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
