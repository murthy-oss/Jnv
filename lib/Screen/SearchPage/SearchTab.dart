import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Screen/profile/profilePage.dart';
import 'getx.dart';

class SearchPage extends StatelessWidget {
  final SearchTabController _controller = Get.put(SearchTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(12 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
              border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller.searchController,
                onChanged: (value) {
                  _controller.performSearch(value.toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _controller
                          .performSearch(_controller.searchController.text.toLowerCase());
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (_controller.searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      'Search Jobs Events Peoples....',
                      style: GoogleFonts.aladin(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _controller.searchResults.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[100],
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileScreen(uid: _controller.searchResults[index]['userId']);
                            },));
                          },
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: _controller.searchResults[index]['profilePicture'] != null
                                    ? CachedNetworkImageProvider(_controller.searchResults[index]['profilePicture']) // Assuming profilePicture is of type String
                                    : AssetImage('Assets/images/Avatar.png') as ImageProvider<Object>? ,
                              ),
                              SizedBox(width: 10.w),

                              Expanded(
                                child: Text(
                                  _controller.searchResults[index]['name'],
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Followers: ${_controller.searchResults[index]['followers'].length.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Following: ${_controller.searchResults[index]['following'].length.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
