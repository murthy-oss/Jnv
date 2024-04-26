import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jnvapp/components/myTextfield.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

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
  late TextEditingController _achievements;
  late TextEditingController _emailController;
  late TextEditingController _instagramcontroller;
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
    _instagramcontroller = TextEditingController();
    _achievements = TextEditingController();

    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _linkController = TextEditingController();
    final userFetchController =
        Provider.of<UserFetchController>(context, listen: false);
    _myUser = userFetchController.myUser;
    _instagramcontroller.text = _myUser.instagramLink ?? '';
    _emailController.text = _myUser.email ?? '';
    _achievements.text = _myUser.achievements ?? '';
    _bioController.text = _myUser.bio ?? '';
    _nameController.text = _myUser.name ?? '';
    _linkController.text = _myUser.linkedinLink ?? '';
    _selectedDate = _myUser.dateOfBirth;
    _image =
        _myUser.profilePicture != null ? File(_myUser.profilePicture!) : null;
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
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent, // LinkedIn-style color
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.share('J.N.V');
              },
              icon: FaIcon(Icons.share, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  height: 180.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 500,
                          height: 100,
                          color: Colors.redAccent,
                        ),
                      ),
                      Positioned(
                        left: 135,
                        top: 25,
                        child: GestureDetector(
                          onTap: _selectImage,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _myUser.profilePicture != ''
                                ? CachedNetworkImageProvider(
                                    _myUser.profilePicture ?? '')
                                : AssetImage('Assets/images/Avatar.png')
                                    as ImageProvider<Object>,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: Text('Change Profile Imagae',style: TextStyle(fontWeight: FontWeight.w700),),),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  children: [
                    MyTextField(
                      controller: _nameController,
                      hint: 'name',
                      keyboardtype: TextInputType.name,
                      obscure: false,
                      selection: true,
                    ),
                   MyTextField(
                  controller: _emailController,
                  hint: 'email',
                  keyboardtype: TextInputType.name,
                  obscure: false,
                  selection: true,
                ),       MyTextField(
                  controller: _bioController,
                  hint: 'bio',
                  keyboardtype: TextInputType.name,
                  obscure: false,
                  selection: true,
                ), MyTextField(
                  controller: _achievements,
                  hint: 'Achievements',
                  keyboardtype: TextInputType.name,
                  obscure: false,
                  selection: true,
                ),  MyTextField(
                  controller: _linkController,
                  hint: 'LinkedIn',
                  keyboardtype: TextInputType.name,
                  obscure: false,
                  selection: true,
                ),       MyTextField(
                  controller: _instagramcontroller,
                  hint: 'Instagram',
                  keyboardtype: TextInputType.name,
                  obscure: false,
                  selection: true,
                ),
                ]),
              ),
              SizedBox(height: 15.h),
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
                      Text(_hideEmail ? 'Show Email' : 'Hide Email',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03)),
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
                      Text(_hidePhone ? 'Show Phone' : 'Hide Phone',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03)),
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
                      Text(_hideLinkedIn ? 'Show LinkedIn' : 'Hide LinkedIn',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final currentUserrUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          final usersCollection =
                              FirebaseFirestore.instance.collection('users');
                          print(currentUserrUid);
                          QuerySnapshot querySnapshot = await usersCollection
                              .where('userId', isEqualTo: currentUserrUid)
                              .get();

                          if (querySnapshot.size == 1) {
                            String documentId = querySnapshot.docs[0].id;

                            await usersCollection.doc(documentId).update({
                              'name': _nameController.text.toLowerCase(),
                              'email': _emailController.text,
                              'bio': _bioController.text,
                              'linkedinLink': _linkController.text,
                              'showEmail': _hideEmail,
                              'showPhone': _hidePhone,
                              'instagramLink': _instagramcontroller.text,
                              'showLinkedin': _hideLinkedIn,
                              'achievements': _achievements.text,
                            });

                            if (_image != null) {
                              String profileImageUrl = await _uploadProfileImage(
                                  currentUserrUid, _image!);
                              await usersCollection
                                  .doc(documentId)
                                  .update({'profilePicture': profileImageUrl});
                            }

                            final userFetchController =
                                Provider.of<UserFetchController>(context,
                                    listen: false);
                            userFetchController.fetchUserData();

                            Navigator.pop(context);
                          } else {
                            print(
                                'User document not found for phone number: $currentUserrUid');
                          }
                        } catch (e) {
                          print('Error updating user profile: $e');
                        }
                      }
                    },
                    text: 'Update',
                    color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }
}
