import 'package:cardiozen/widgets/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  String gender = "man";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(60, 50),
                elevation: 3,
              ),
              icon: const Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "images/avatar.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text("Upload Image"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const EditItem(
                title: "Name",
                widget: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Gender",
                widget: Row(
                  children: [
                    _buildGenderButton(Ionicons.male, "man"),
                    const SizedBox(width: 20),
                    _buildGenderButton(Ionicons.female, "woman"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const EditItem(
                widget: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your age',
                  ),
                ),
                title: "Age",
              ),
              const SizedBox(height: 40),
              const EditItem(
                widget: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
                title: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildGenderButton(IconData icon, String selectedGender) {
    return IconButton(
      onPressed: () {
        setState(() {
          gender = selectedGender;
        });
      },
      style: IconButton.styleFrom(
        backgroundColor: gender == selectedGender
            ? Colors.deepPurple
            : Colors.grey.shade200,
        fixedSize: const Size(50, 50),
        shape: const CircleBorder(),
      ),
      icon: Icon(
        icon,
        color: gender == selectedGender ? Colors.white : Colors.black,
        size: 24,
      ),
    );
  }
}
