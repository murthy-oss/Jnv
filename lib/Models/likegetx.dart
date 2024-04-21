import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostController extends GetxController {
  final _isLiking = false.obs;
  bool get isLiking => _isLiking.value;
  final Map<String, bool> _showAllDescriptions = {};
  final Map<String, RxBool> _editingStates = {};
  late TextEditingController descriptionController;

  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  void setLiking(bool value) {
    _isLiking.value = value;
  }

  void showDescription(String postId, bool value) {
    _showAllDescriptions[postId] = value;
    update();
  }

  bool isShowingDescription(String postId) {
    return _showAllDescriptions[postId] ?? false;
  }

  void toggleEditing(String postId, bool value) {
    if (!_editingStates.containsKey(postId)) {
      _editingStates[postId] = RxBool(value);
      update();
    } else {
      _editingStates[postId]!.value = value;
      update();
    }
  }

  bool isEditing(String postId) {
    if (_editingStates.containsKey(postId)) {
      return _editingStates[postId]!.value;
    }
    return false;
  }

  void updateDescription(String postId, String newDescription) {
    if (newDescription.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({'description': newDescription})
          .then((_) {
        toggleEditing(postId, false);
        print('Description updated successfully');
      }).catchError((error) {
        print('Error updating description: $error');
      });
    } else {
      print('New description is empty');
    }
  }

}
