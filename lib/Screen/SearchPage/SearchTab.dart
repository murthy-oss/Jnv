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
                      return ListTile(
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
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller.searchResults[index]['name'],
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),

                                  ),
                                  Text(_controller.searchResults[index]['NavodhyaId']??"N-***** ", style: GoogleFonts.inter(fontWeight: FontWeight.w500,color:Colors.grey)),
                                ],
                              ),
                            ),

                          ],
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
