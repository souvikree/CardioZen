import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  // Add other controllers for features

  String _prediction = '';

  void _predict() async {
    final prediction = await ApiService().getPrediction({
      'age': int.parse(_ageController.text),
      'sex': int.parse(_sexController.text),
      // Add other features here
    });
    setState(() {
      _prediction = prediction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Disease Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextField(controller: _ageController, hintText: 'Age', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            CustomTextField(controller: _sexController, hintText: 'Sex', keyboardType: TextInputType.number),
            // Add other text fields here
            const SizedBox(height: 32),
            CustomButton(onPressed: _predict, text: 'Predict'),
            const SizedBox(height: 16),
            Text(_prediction),
          ],
        ),
      ),
    );
  }
}
