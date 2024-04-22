import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchChat extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxList<DocumentSnapshot> searchResults = RxList<DocumentSnapshot>();

  void ChatSearch(String query) async {
    try {
      List<DocumentSnapshot> results = [];
query=query.toLowerCase();
      // Search for chat rooms where the current user is a member
      QuerySnapshot chatRoomSnapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Extract other user's UID from chat rooms
      List<String> otherUserUids = chatRoomSnapshot.docs.map((doc) {
        List<dynamic> users = doc['users'];
        users.remove(FirebaseAuth.instance.currentUser!.uid);
        return users.isNotEmpty ? users[0] as String : ''; // Cast to String here
      }).toList();

      // Search for users based on otherUserUids and query
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: otherUserUids)
          .where('name', isEqualTo: query)
          .get();

      results.addAll(userSnapshot.docs);

      searchResults.assignAll(results);
    } catch (e) {
      print('Error performing search: $e');
    }
  }
}
