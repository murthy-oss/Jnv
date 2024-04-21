import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
<<<<<<< HEAD
import 'package:jnvapp/AuthScreens/HomePage.dart';

=======
import 'package:jnvapp/screens/HomePage.dart';
>>>>>>> origin/main
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Services/FireStoreMethod.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({Key? key}) : super(key: key);

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Uint8List? _file;
  Uuid uuid = Uuid();

  Future<Uint8List?> _selectImage(BuildContext parentContext) async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List fileBytes = await pickedFile.readAsBytes();
      return fileBytes;
    }
    return null;
  }

  late UserFetchController userFetchController;

  @override
  void initState() {
    super.initState();
    userFetchController =
        Provider.of<UserFetchController>(context, listen: false);
    userFetchController.fetchUserData();
  }

  String? _validateInput(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (fieldName == 'Email') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
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
              SizedBox(height: 58),
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
                        Uint8List? file = await _selectImage(context);
                        if (file != null) {
                          setState(() {
                            _file = file;
                          });
                        }
                      },
                      text: "Upload Photo",
                      color: Color(0xFF888BF4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              MyTextField(
                controller: _nameController,
                hint: "Name",
                obscure: false,
                selection: true,
                preIcon: Icons.drive_file_rename_outline,
                keyboardtype: TextInputType.name,
                validator: (value) => _validateInput(value, fieldName: 'Name'),
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
              SizedBox(height: 15),
              // Date of Birth Picker
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
                        dateOfBirth: '',
                        gender: '',
                        email: _emailController.text.trim(),
                        phoneNumber: '',
                        aadharCardNumber: '',
                        maritalStatus: '',
                        occupation: '',
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
                        context: context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all the fields correctly and select Date of Birth',
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
