// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:cardiozen/Screen/register_screen.dart';
import 'package:cardiozen/Utils/colors.dart';
import 'package:cardiozen/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
 // Import HomeScreen

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final url = Uri.parse('http://192.168.0.129:8000/api/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              backgroundColor2,
              backgroundColor2,
              backgroundColor4,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                "Hello Again!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 37,
                  color: textColor1,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Welcome back, you've\nbeen missed!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, color: textColor2, height: 1.2),
              ),
              SizedBox(height: size.height * 0.04),
              myTextField("Email", Colors.white, _emailController),
              myTextField("Password", Colors.black26, _passwordController),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password               ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor2,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black12,
                        ),
                        Text(
                          "  Or continue with   ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor2,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          height: 2,
                          width: size.width * 0.2,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        socialIcon("images/google.png"),
                        socialIcon("images/apple.png"),
                        socialIcon("images/facebook.png"),
                      ],
                    ),
                    SizedBox(height: size.height * 0.07),
                    Text.rich(
                      TextSpan(
                        text: "Don't you have an account? ",
                        style: TextStyle(
                          color: textColor2,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "Register now",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Register(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container socialIcon(String image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Image.asset(
        image,
        height: 35,
      ),
    );
  }

  Container myTextField(String hint, Color color, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 19,
          ),
          suffixIcon: Icon(
            hint == "Password" ? Icons.visibility_off_outlined : null,
            color: color,
          ),
        ),
        obscureText: hint == "Password" ? true : false,
      ),
    );
  }
}
