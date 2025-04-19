import 'package:flutter/material.dart';

class PhoneNumberInput extends StatefulWidget {
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String selectedCountryCode = "+33"; // Default to France
  List<String> countryCodes = ["+1", "+33", "+91", "+44"]; // Add more country codes as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Number Input")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Dropdown for country code
            DropdownButton<String>(
              value: selectedCountryCode,
              
              items: countryCodes.map((String code) {
                return DropdownMenuItem<String>(
                  
                  value: code,
                  child: Row(
                    children: [
                      // Here you can add flags for respective countries if needed
                      Text(
                        code,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCountryCode = newValue!;
                });
              },
            ),
            SizedBox(width: 10), // Space between dropdown and text field
            // Phone number input field
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PhoneNumberInput(),
  ));
}
