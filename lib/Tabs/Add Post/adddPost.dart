import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  List<AssetEntity> _selectedAssets = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraInitialized = true;
      });
    });
  }
  // void _postImage() async {
  //   if (_file == null || _descriptionController.text.isEmpty) {
  //     showSnackBar(context, 'Please select an image and enter a description.');
  //     return;
  //   }
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     String res = await FireStoreMethods().uploadPost(
  //       _descriptionController.text,
  //       _file!,
  //       widget.uid,
  //       userName,
  //       userProfile,
  //     );
  //     if (res == 'success') {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (context.mounted) {
  //         showSnackBar(context, 'Posted!');
  //       }
  //       _clearImage();
  //     } else {
  //       if (context.mounted) {
  //         showSnackBar(context, res);
  //       }
  //     }
  //   } catch (err) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackBar(context, err.toString());
  //   }
  // }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(context);
    if (result != null) {
      setState(() {
        _selectedAssets = List<AssetEntity>.from(result);
      });
    }
  }

  Widget _buildSelectedImages() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _selectedAssets.length,
      itemBuilder: (context, index) {
        return AssetThumbnail(
          asset: _selectedAssets[index],
          onTap: () {
            // Add logic to view or remove the selected image
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        actions: [
          IconButton(
            onPressed: _pickImages,
            icon: Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController)
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: _selectedAssets.isEmpty
                ? Center(
              child: Text('No images selected'),
            )
                : _buildSelectedImages(),
          ),
          ElevatedButton(
            onPressed: () {
              // Add logic to upload the selected images
            },
            child: Text('Upload Post'),
          ),
        ],
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const AssetThumbnail({
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: AssetEntityImage(
          asset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
