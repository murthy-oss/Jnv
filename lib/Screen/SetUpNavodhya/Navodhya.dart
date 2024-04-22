import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../AuthScreens/HomePage.dart';
import '../../Services/FireStoreMethod.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetUpNavodhya extends StatefulWidget {
  const SetUpNavodhya({Key? key}) : super(key: key);

  @override
  State<SetUpNavodhya> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpNavodhya> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _schoolCampusController = TextEditingController();
  final TextEditingController _entryYearController = TextEditingController();
  final TextEditingController _entryClassController = TextEditingController();

  Uuid uuid = Uuid();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  String? _validateInput(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (fieldName == 'Email') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    } else if (fieldName == 'Gender') {
      if (value != 'Male' && value != 'Female' && value != 'Others') {
        return 'Please select a valid gender';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 85.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add your",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Information and",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Navodhya Details",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: _stateController,
                hint: "Selection - State",
                obscure: false,
                selection: true,
                preIcon: Icons.location_on,
                keyboardtype: TextInputType.text,
                validator: (value) =>
                    _validateInput(value, fieldName: 'State'),
              ),
              MyTextField(
                controller: _districtController,
                hint: "Selection - District",
                obscure: false,
                selection: true,
                preIcon: Icons.location_city,
                keyboardtype: TextInputType.text,
                validator: (value) =>
                    _validateInput(value, fieldName: 'District'),
              ),
              MyTextField(
                controller: _schoolCampusController,
                hint: "Selection - School Campus",
                obscure: false,
                selection: true,
                preIcon: Icons.school,
                keyboardtype: TextInputType.text,
                validator: (value) =>
                    _validateInput(value, fieldName: 'School Campus'),
              ),
              MyTextField(
                controller: _entryYearController,
                hint: "Entry Year",
                obscure: false,
                selection: true,
                preIcon: Icons.date_range,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Entry Year'),
              ),
              MyTextField(
                controller: _entryClassController,
                hint: "Entry Class",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Entry Class'),
              ),
              SizedBox(height: 15),
              MyButton(
                onTap: () {
                  String? nameError =
                  _validateInput(_nameController.text, fieldName: 'Name');
                  String? emailError =
                  _validateInput(_emailController.text, fieldName: 'Email');
                  if (nameError == null && emailError == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all the fields correctly',
                        ),
                      ),
                    );
                  }
                },
                text: "Select And Continue",
                color: Color(0xFF888BF4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
