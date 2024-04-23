import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Models/UserFetchDataModel.dart';
import '../../components/myButton.dart';
import 'editProfileGetx.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _linkController;
  late TextEditingController _bioController;
  String? _selectedDate;
  File? _image;
  late UserModel1 _myUser;
  final _formKey = GlobalKey<FormState>();
  bool _hideEmail = false;
  bool _hidePhone = false;
  bool _hideLinkedIn = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _linkController = TextEditingController();
    final userFetchController = Provider.of<UserFetchController>(context, listen: false);
    _myUser = userFetchController.myUser;
    _nameController.text = _myUser.name ?? '';
    _emailController.text = _myUser.email ?? '';
    _bioController.text = _myUser.bio ?? '';
    _linkController.text = _myUser.linkedinLink ?? '';
    _selectedDate = _myUser.dateOfBirth;
    _image = _myUser.profilePicture != null ? File(_myUser.profilePicture!) : null;
    _hideEmail = _myUser.showEmail;
    _hidePhone = _myUser.showPhone;
    _hideLinkedIn = _myUser.showLinkedin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your bio';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('profile_images').child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // LinkedIn-style color
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _selectImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: CachedNetworkImageProvider(_myUser.profilePicture ?? ''),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'LinkdIn',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                validator: _validateBio,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              GestureDetector(
                // onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null ? 'DOB: ${_selectedDate}' : 'Select Date of Birth',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: !_hideEmail,
                        onChanged: (value) {
                          setState(() {
                            _hideEmail = !_hideEmail;
                          });
                        },
                      ),
                      Text(_hideEmail ? 'Show Email' : 'Hide Email', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: !_hidePhone,
                        onChanged: (value) {
                          setState(() {
                            _hidePhone = !_hidePhone;
                          });
                        },
                      ),
                      Text(_hidePhone ? 'Show Phone' : 'Hide Phone', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: !_hideLinkedIn,
                        onChanged: (value) {
                          setState(() {
                            _hideLinkedIn = !_hideLinkedIn;
                          });
                        },
                      ),
                      Text(_hideLinkedIn ? 'Show LinkedIn' : 'Hide LinkedIn', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyButton1(onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final currentUserrUid = FirebaseAuth.instance.currentUser!.uid;
                    final usersCollection = FirebaseFirestore.instance.collection('users');
print(currentUserrUid);
                    QuerySnapshot querySnapshot =
                        await usersCollection.where('userId', isEqualTo: currentUserrUid).get();

                    if (querySnapshot.size == 1) {
                      String documentId = querySnapshot.docs[0].id;

                      await usersCollection.doc(documentId).update({
                        'name': _nameController.text,
                        'email': _emailController.text,

                        'bio': _bioController.text,
                        'linkedinLink': _linkController.text,
                        'showEmail': _hideEmail,
                        'showPhone': _hidePhone,
                        'showLinkedin': _hideLinkedIn,
                      });

                      if (_image != null) {
                        String profileImageUrl = await _uploadProfileImage(currentUserrUid, _image!);
                        await usersCollection.doc(documentId).update({'profilePicture': profileImageUrl});
                      }

                      final userFetchController = Provider.of<UserFetchController>(context, listen: false);
                      userFetchController.fetchUserData();

                      Navigator.pop(context);
                    } else {
                      print('User document not found for phone number: $currentUserrUid');
                    }
                  } catch (e) {
                    print('Error updating user profile: $e');
                  }
                }
              }, text: 'Save Changes', color: Colors.blue)


            ],
          ),
        ),
      ),
    );
  }
}
