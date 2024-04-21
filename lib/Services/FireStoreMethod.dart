import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Models/PostModel.dart';
import '../Models/UserModel.dart';
import '../components/MyToast.dart';
import 'StorageMethods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(
      String postId, String uid, List likes, String targetUserId) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        LikeNotification(currentUserId, targetUserId, postId);
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic, String TargetUserId) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
        final currentUserID = FirebaseAuth.instance.currentUser!.uid;
        CommentNotification(currentUserID, TargetUserId, postId);
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String currentUserUid, String targetUserUid) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Get the current user's data
      DocumentSnapshot currentUserSnapshot =
          await usersCollection.doc(currentUserUid).get();
      if (!currentUserSnapshot.exists) {
        print('Current user not found');
        return;
      }
      Map<String, dynamic> currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>;

      // Get the target user's data
      DocumentSnapshot targetUserSnapshot =
          await usersCollection.doc(targetUserUid).get();
      if (!targetUserSnapshot.exists) {
        print('Target user not found');
        return;
      }
      Map<String, dynamic> targetUserData =
          targetUserSnapshot.data() as Map<String, dynamic>;

      // Check if the current user is not the same as the target user
      if (currentUserUid != targetUserUid) {
        // Add the current user to the target user's followers list
        await usersCollection.doc(targetUserUid).update({
          'followers': FieldValue.arrayUnion([
            {
              'uid': currentUserUid,
              'name': currentUserData['name'],
              'profilePhotoUrl': currentUserData['profilePhotoUrl'],
            }
          ])
        });

        // Add the target user to the current user's following list
        await usersCollection.doc(currentUserUid).update({
          'following': FieldValue.arrayUnion([
            {
              'uid': targetUserUid,
              'name': targetUserData['name'],
              'profilePhotoUrl': targetUserData['profilePhotoUrl'],
            }
          ])
        });
        sendFollowNotification(currentUserUid, targetUserUid);
      } else {
        print('Cannot follow yourself');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> unfollowUser(String currentUserUid, String targetUserUid) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');

      // Get the current user's data
      DocumentSnapshot currentUserSnapshot =
          await usersCollection.doc(currentUserUid).get();
      if (!currentUserSnapshot.exists) {
        print('Current user not found');
        return;
      }
      Map<String, dynamic> currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>;

      // Get the target user's data
      DocumentSnapshot targetUserSnapshot =
          await usersCollection.doc(targetUserUid).get();
      if (!targetUserSnapshot.exists) {
        print('Target user not found');
        return;
      }
      Map<String, dynamic> targetUserData =
          targetUserSnapshot.data() as Map<String, dynamic>;

      // Remove the current user from the target user's followers list
      await usersCollection.doc(targetUserUid).update({
        'followers': FieldValue.arrayRemove([
          {
            'uid': currentUserUid,
            'name': currentUserData['name'],
            'profilePhotoUrl': currentUserData['profilePhotoUrl'],
          }
        ])
      });

      // Remove the target user from the current user's following list
      await usersCollection.doc(currentUserUid).update({
        'following': FieldValue.arrayRemove([
          {
            'uid': targetUserUid,
            'name': targetUserData['name'],
            'profilePhotoUrl': targetUserData['profilePhotoUrl'],
          }
        ])
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> createFollowersAndFollowingArrays(
      String bio, String Linkedin) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Create an array of followers for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .set({
        'LinkedIn': Linkedin,
        'showEmail': true,
        'showPhone': true,
        'showLinkedin': true,
        'bio': bio,
        'followers': [], // Initialize with an empty array
      }, SetOptions(merge: true)); // Merge with existing document if it exists

      // Create an array of following for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .set({
        'following': [], // Initialize with an empty array
      }, SetOptions(merge: true)); // Merge with existing document if it exists

      print('Followers and following arrays created successfully.');
    } catch (e) {
      print('Error creating followers and following arrays: $e');
    }
  }

  Future<void> createUser({
    required String userId,
    required String name,
    required String dateOfBirth,
    required String gender,
    required String email,
    required String phoneNumber,
    required String aadharCardNumber,
    required String maritalStatus,
    required String occupation,
    required String section,
    required String state,
    required String district,
    required String schoolCampus,
    required String entryYear,
    required String entryClass,
    required String passOutYear,
    required String house,
    required String profilePicture,
    required String bio,
    required String achievements,
    required String instagramLink,
    required String linkedinLink,
    required bool IsVerified,
    required BuildContext context,
    Uint8List? imageBytes,
  }) async {
    try {
      // Check if user already exists with the provided email
      QuerySnapshot existingUsersWithEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsersWithEmail.docs.isNotEmpty) {
        // User already exists with the provided email, handle this case
        print('User with email $email already exists.');
        // You might want to return here or show an error message to the user
        return;
      }

      // Check if user already exists with the provided UID
      DocumentSnapshot existingUserWithUid = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (existingUserWithUid.exists) {
        // User already exists with the provided UID, handle this case
        print('User with UID $userId already exists.');
        // You might want to return here or show an error message to the user
        return;
      }

      String imageUrl = profilePicture; // Default to profilePhotoUrl

      if (imageBytes != null) {
        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$userId.jpg');
        UploadTask uploadTask = ref.putData(imageBytes);
        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      var user = UserModel(
          IsVerified: false,
          userId: userId,
          name: name,
          dateOfBirth: dateOfBirth,
          gender: gender,
          email: email,
          phoneNumber: phoneNumber,
          aadharCardNumber: aadharCardNumber,
          maritalStatus: maritalStatus,
          occupation: occupation,
          section: section,
          state: state,
          district: district,
          schoolCampus: schoolCampus,
          entryYear: entryYear,
          entryClass: entryClass,
          passOutYear: passOutYear,
          house: house,
          profilePicture: profilePicture,
          bio: bio,
          achievements: achievements,
          instagramLink: instagramLink,
          linkedinLink: linkedinLink);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user.toMap());

      createFollowersAndFollowingArrays(bio, linkedinLink);

      // Navigator.pushReplacement(
      //   context,
      //   PageRouteBuilder(
      //     transitionDuration: Duration(milliseconds: 500),
      //     pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       var begin = Offset(0.0, 1.0);
      //       var end = Offset.zero;
      //       var curve = Curves.ease;
      //
      //       var tween = Tween(begin: begin, end: end).chain(
      //         CurveTween(curve: curve),
      //       );
      //
      //       return SlideTransition(
      //         position: animation.drive(tween),
      //         child: child,
      //       );
      //     },
      //   ),
      // );
    } catch (e) {
      print('Error creating user: $e');
      // Handle error here, e.g., show an error dialog to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to create user. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> sendFollowNotification(
      String currentUserId, String targetUserId) async {
    try {
      // Fetch current user's data
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      String currentUserName = currentUserSnapshot.get('name');

      // Fetch target user's data
      DocumentSnapshot targetUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .get();
      String targetUserName = targetUserSnapshot.get('name');

      // Add notification to target user's notifications collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add({
        'notification': '$currentUserName started following you',
        'id': currentUserId,
        'dateTime': Timestamp.now(),
      });

      ToastUtil.showToastMessage("Following $targetUserName");
    } catch (error) {
      print(error);
      ToastUtil.showToastMessage("Cannot Follow User: Internal Error");
    }
  }

  Future<void> LikeNotification(
      String currentUserId, String targetUserId, String PostID) async {
    try {
      // Fetch current user's data
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      String currentUserName = currentUserSnapshot.get('name');

      // Add notification to target user's notifications collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add({
        'notification': '$currentUserName Liked Your Post',
        'id': currentUserId,
        'dateTime': Timestamp.now(),
        'PostID': PostID,
      });
    } catch (error) {
      print(error);
      ToastUtil.showToastMessage("Cannot Follow User: Internal Error");
    }
  }

  Future<void> CommentNotification(
      String currentUserId, String targetUserId, String PostID) async {
    try {
      // Fetch current user's data
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      String currentUserName = currentUserSnapshot.get('name');

      // Add notification to target user's notifications collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add({
        'notification': '$currentUserName Commented on Your Post',
        'id': currentUserId,
        'dateTime': Timestamp.now(),
        'PostID': PostID
      });

      ToastUtil.showToastMessage("Commented Successfully");
    } catch (error) {
      print(error);
      ToastUtil.showToastMessage("Cannot Comment : Internal Error");
    }
  }

  Future<String> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      return 'success';
    } catch (e) {
      return 'Error deleting comment: $e';
    }
  }
}
