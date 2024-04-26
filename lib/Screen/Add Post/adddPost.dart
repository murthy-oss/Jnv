import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Services/FireStoreMethod.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  final String uid;

  const AddPostScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  late String userProfile = '';
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    setUp();
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> setUp() async {
    final usersnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    setState(() {
      userName = usersnapshot['name'];
      userProfile = usersnapshot['profilePicture'];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _file = bytes;
      });
    }
  }

  Widget _buildCameraPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildAddImagePlaceholder() {
    return Stack(
      children: [
        _buildCameraPreview(),
        GestureDetector(
          onTap: () => _selectImage(ImageSource.gallery), // Open gallery directly
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Text(
                'Tap to add an image',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: IconButton(
            onPressed: () {
              // Add logic to flip camera here
            },
            icon: Icon(Icons.flip_camera_ios),
            color: Colors.white,
            iconSize: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            if (_file != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(
                  _file!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userProfile),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              enableSuggestions: true,
              maxLength: 800,
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Write a caption...",
                border: InputBorder.none,
              ),
              maxLines: 8,
            ),
          ),
        ],
      ),
    );
  }

  void _postImage() async {
    if (_file == null || _descriptionController.text.isEmpty) {
      showSnackBar(context, 'Please select an image and enter a description.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        widget.uid,
        userName,
        userProfile,
      );
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(context, 'Posted!');
        }
        _clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, err.toString());
    }
  }

  void _clearImage() {
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Post to',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: <Widget>[
            TextButton(
              onPressed: _postImage,
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  if (isLoading) const LinearProgressIndicator(),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildImagePreview(),
                  _buildCaptionInput(),
                  const Divider(),
                ],
              ),
              if (_file == null) _buildAddImagePlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}
