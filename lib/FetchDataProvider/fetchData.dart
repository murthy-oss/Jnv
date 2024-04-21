import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/UserFetchDataModel.dart';

class UserFetchController extends ChangeNotifier {
  UserModel1 _myUser = UserModel1();
  bool _isDataFetched = false; // Flag to track if data is fetched

  UserModel1 get myUser => _myUser;

  bool get isDataFetched => _isDataFetched;

  void fetchUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('User not logged in');
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .where('userId',
        isEqualTo: currentUser.uid) // Filter documents by phone number
        .snapshots() // Listen for real-time updates to the filtered documents
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        _myUser = UserModel1.fromJson(userData);
        _isDataFetched = true;
        // Set data fetched flag to true
        notifyListeners(); // Notify listeners about the change
      } else {
        print('User data not found');
      }
    }, onError: (error) {
      print('Error fetching user info: $error');
    });
  }
}