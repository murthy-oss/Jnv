import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jnvapp/AuthScreens/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../FetchDataProvider/fetchData.dart';
import '../../Services/FireStoreMethod.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../SetUpNavodhya/Navodhya.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({Key? key}) : super(key: key);

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  String? _selectedOccupation; // Corrected variable name
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController(); // Defined _occupationController

  Uint8List? _file;
  Uuid uuid = Uuid();

  Future<void> _selectImage(BuildContext parentContext) async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List fileBytes = await pickedFile.readAsBytes();
      setState(() {
        _file = fileBytes;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                "Profile photo",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: _file != null
                          ? MemoryImage(_file!)
                      as ImageProvider // Cast MemoryImage to ImageProvider
                          : AssetImage('Assets/images/Avatar.png')
                      as ImageProvider, // Cast AssetImage to ImageProvider
                      radius: 60,
                    ),

                    MyButton1(
                      onTap: () async {
                        await _selectImage(context);
                      },
                      text: "Upload Photo",
                      color: Color(0xFF888BF4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _nameController,
                hint: "Name",
                obscure: false,
                selection: true,
                preIcon: Icons.drive_file_rename_outline,
                keyboardtype: TextInputType.name,
                validator: (value) => _validateInput(value, fieldName: 'Name'),
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                },
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: _dobController,
                    hint: "Date of Birth",
                    obscure: false,
                    selection: true,
                    preIcon: Icons.calendar_today,
                    keyboardtype: TextInputType.datetime,
                    validator: (value) => _validateInput(value, fieldName: 'Date of Birth'),
                  ),
                ),
              ),
              MyTextField(
                controller: _emailController,
                hint: "Email",
                obscure: false,
                selection: true,
                preIcon: Icons.mail,
                keyboardtype: TextInputType.emailAddress,
                validator: (value) => _validateInput(value, fieldName: 'Email'),
              ),
              MyTextField(
                controller: _mobileController,
                hint: "Mobile",
                obscure: false,
                selection: true,
                preIcon: Icons.phone,
                keyboardtype: TextInputType.phone,
                validator: (value) => _validateInput(value, fieldName: 'Mobile'),
              ),
              MyTextField(
                controller: _aadhaarController,
                hint: "Aadhaar",
                obscure: false,
                selection: true,
                preIcon: Icons.credit_card,
                keyboardtype: TextInputType.number,
                validator: (value) => _validateInput(value, fieldName: 'Aadhaar'),
              ),
              MyTextField(
                controller: _maritalStatusController,
                hint: "Marital Status",
                obscure: false,
                selection: true,
                preIcon: Icons.favorite,
                keyboardtype: TextInputType.text,
                validator: (value) => _validateInput(value, fieldName: 'Marital Status'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Others'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select Gender',
                  prefixIcon: Icon(Icons.people),
                ),
                validator: (value) => _validateInput(value, fieldName: 'Gender'),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedOccupation,
                items: ['Student', 'Teacher'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOccupation = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select Occupation',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) => _validateInput(value, fieldName: 'Occupation'),
              ),
              SizedBox(height: 15),
              MyButton(
                onTap: () {
                  String? nameError =
                  _validateInput(_nameController.text, fieldName: 'Name');
                  String? emailError =
                  _validateInput(_emailController.text, fieldName: 'Email');
                  if (nameError == null && emailError == null) {
                    FireStoreMethods().createUser(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      name: _nameController.text.toLowerCase(),
                      dateOfBirth: _dobController.text,
                      gender: _selectedGender!,
                      email: _emailController.text.trim(),
                      phoneNumber: "91${_mobileController.text}",
                      aadharCardNumber: _aadhaarController.text,
                      maritalStatus: _maritalStatusController.text,
                      occupation: _selectedOccupation!,
                      section: '',
                      state: '',
                      district: '',
                      schoolCampus: '',
                      entryYear: '',
                      entryClass: '',
                      passOutYear: '',
                      house: '',
                      profilePicture: '',
                      bio: '',
                      achievements: '',
                      instagramLink: '',
                      linkedinLink: '',
                      IsVerified: false,
                      context: context,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SetUpNavodhya();
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
