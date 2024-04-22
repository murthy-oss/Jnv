import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileController extends GetxController {
  final String uid;

  ProfileController({required this.uid});

  RxMap userData = {}.obs;
  RxInt postLen = 0.obs;
  RxInt followers = 0.obs;
  RxInt following = 0.obs;
  RxBool isFollowing = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    isLoading.value = true;

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('uuid', isEqualTo: uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userSnap.docs.isNotEmpty) {
        var userDataDoc = userSnap.docs.first;
        userData = userDataDoc.data().obs;
        followers.value = userData['followers'].length;
        following.value = userData['following'].length;
        isFollowing.value = userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
        postLen.value = postSnap.docs.length;
      } else {
        Get.snackbar('Error', 'User data not found.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }

    isLoading.value = false;
  }

  Future<QuerySnapshot> getUserPosts() async {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .get();
  }
}
