// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation logic here
      // For now, just print the selected index
      // ignore: avoid_print
      print('Selected index: $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B39EF), // Set the AppBar background color
        title: const Text(
          'CardioZen',
          style: TextStyle(
            color: Colors.white, // Set the title color to white
            fontWeight: FontWeight.bold, // Set the title font to bold
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white, // Set the icon color to white
            ),
            onPressed: () {
              // Handle notification icon press
              // For now, just print a message
              // ignore: avoid_print
              print('Notification icon pressed');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to CardioZen!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, 1),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: _buildPredictIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.history, 3),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.help, 4),
            label: 'Help',
          ),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 5,
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(20), // 50% of the width and height
      ),
      child: Center(
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPredictIcon() {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: _selectedIndex == 2 ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Center(
        child: Text(
          'Predict',
          style: TextStyle(
            color: _selectedIndex == 2 ? Colors.white : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
