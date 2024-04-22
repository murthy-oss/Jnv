import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SearchTabController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxList<DocumentSnapshot> searchResults = RxList<DocumentSnapshot>();

  void performSearch(String query) async {
    try {
      List<DocumentSnapshot> results = [];
query=query.toLowerCase();
      // Search for users
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(usersSnapshot.docs);

      // Search for events
      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(eventsSnapshot.docs);

      // Search for jobs
      QuerySnapshot jobsSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      results.addAll(jobsSnapshot.docs);

      searchResults.assignAll(results);
    } catch (e) {
      print('Error performing search: $e');
    }
  }
}
