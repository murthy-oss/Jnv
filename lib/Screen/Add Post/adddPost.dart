import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
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
    final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> setUp() async {
    final usersnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
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
      ],
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 450.h,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
            height: 100.h,
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
  Future<void> _captureImage() async {
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Take the picture
      final XFile? file = await _controller.takePicture();

      if (file != null) {
        // Convert the XFile to Uint8List
        final Uint8List? imageData = await file.readAsBytes();

        if (imageData != null) {
          // Update the state with the new image
          setState(() {
            _file = imageData;
          });
        }
      }
    } catch (e) {
      // Handle any errors
      print('Error capturing image: $e');
    }
  }

  Future<void> _toggleCameraLensDirection() async {
    // Check if the current camera is the front camera
    if (_controller.value.description.lensDirection == CameraLensDirection.front) {
      // Switch to the back camera
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      _controller = CameraController(backCamera, ResolutionPreset.medium);
    } else {
      // Switch to the front camera
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);
      _controller = CameraController(frontCamera, ResolutionPreset.medium);
    }

    // Reinitialize the camera controller
    _initializeControllerFuture = _controller.initialize();
    setState(() {}); // Trigger a rebuild to update the UI
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'post',
            style: GoogleFonts.inter(color: Colors.black, fontSize: 25.sp),
          ),
          actions: <Widget>[
            if (_file == null) IconButton(
                onPressed: _postImage,
                icon: FaIcon(
                  Bootstrap.lightning_charge,
                  color: Colors.black,
                )),
              if (_file != null) IconButton(
                onPressed: _postImage,
                icon: FaIcon(
                 Bootstrap.arrow_right,
                  color: Colors.red,
                )),
            
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  if (isLoading) const LinearProgressIndicator(),
                  const Divider(),
                  _buildImagePreview(),
                  if (_file == null)Container(height: 100.h,),
                  if (_file != null)_buildCaptionInput()
                ],
              ),
              if (_file == null) _buildAddImagePlaceholder(),
              if (_file == null)   Positioned(
                bottom:
                0, // This positions the container at the bottom of the stack
                left: 0, // Optional: Aligns the container to the left
                right: 0, // Optional: Centers the container horizontally
                child: Container(
                  height: 10,
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,

                        child: GestureDetector(
                          child:   FaIcon(Iconsax.gallery_add_bold,color: Colors.black,size: 35.r,),

                          onTap: () async {
                            // Open the WeChat asset picker
                            final List<AssetEntity>? result = await AssetPicker
                                .pickAssets(
                              context,
                              permissionRequestOption: PermissionRequestOption(
                                  androidPermission: AndroidPermission(
                                      type: RequestType.all,
                                      mediaLocation: true)), // Limit the selection to one asset// Specify the type of assets to pick
                            );

                            if (result != null && result.isNotEmpty) {
                              // Handle the selected asset
                              final AssetEntity asset = result.first;
                              File? file = await asset.file;
                              if (file != null) {
                                // Read the file into a Uint8List
                                Uint8List? fileData = await file.readAsBytes();
                                _file = fileData;
                                setState(() {

                                });
                              }
                            }
                          }
                        ),),
                      GestureDetector(
                        onTap: _captureImage,
                        child: FaIcon(Icons.camera,
                          size: 40.r,

                        ),
                      ),
                      GestureDetector(onTap: () => _toggleCameraLensDirection,
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                         child: IconButton(onPressed: () {

                         }, icon: FaIcon(Icons.flip_camera_android,color: Colors.black,size: 35.r,)),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

