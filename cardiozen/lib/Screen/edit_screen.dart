import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  String username = "John Doe";
  String email = "john.doe@example.com";
  String? age;
  String? gender;
  bool isEditing = false;

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
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "images/avatar.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (isEditing)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo_outlined, size: 25),
                          onPressed: () {
                            // Add your upload image functionality here
                          },
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoBox("Name", username, (value) {
                setState(() {
                  username = value;
                });
              }),
              const SizedBox(height: 20),
              _buildInfoBox("Email", email, (value) {
                setState(() {
                  email = value;
                });
              }),
              const SizedBox(height: 20),
              _buildInfoBox("Age", age ?? "Not Provided", (value) {
                setState(() {
                  age = value;
                });
              }),
              const SizedBox(height: 20),
              _buildGenderBox(),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  child: Text(
                    isEditing ? "Save" : "Edit Profile",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30), // Fully rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: isEditing
                  ? TextField(
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        border: InputBorder.none,
                        hintText: 'Enter your $label',
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30), // Fully rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildGenderButton(Ionicons.male, "man"),
                        const SizedBox(width: 10),
                        _buildGenderButton(Ionicons.female, "woman"),
                      ],
                    )
                  : Row(
                      children: [
                        if (gender == "man") _buildGenderIcon(Ionicons.male),
                        if (gender == "woman") _buildGenderIcon(Ionicons.female),
                        if (gender == null) const Text("Not Provided"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(IconData icon, String selectedGender) {
    return Padding(
      padding: const EdgeInsets.only(left: 12), // Adjust the padding as needed
      child: IconButton(
        onPressed: isEditing
            ? () {
                setState(() {
                  gender = selectedGender;
                });
              }
            : null,
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
      ),
    );
  }

  Widget _buildGenderIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Icon(
        icon,
        size: 24,
        color: Colors.deepPurple,
      ),
    );
  }
}
