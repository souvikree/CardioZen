import 'package:cardiozen/Screen/spash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/prediction_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioZen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash_screen',
      routes: {
        // '/home': (context) => const HomeScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/register': (context) => const RegistrationScreen(),
        // '/prediction': (context) => const PredictionScreen(),
        '/splash_screen': (context) => const MySplashScreen(),

        
      },
    );
  }
}
