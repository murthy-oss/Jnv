import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class Settings1 extends StatelessWidget {
  final String Image;
  final String email;
  final String name;
  Settings1({required this.Image,required this.email, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [

                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage:Image!=''? CachedNetworkImageProvider(Image):AssetImage('Assets/images/Avatar.png')as ImageProvider<Object>,
                  ),
                  SizedBox(width: 15.w,),
                  Column(
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, fontSize: 22.sp)),
                      Text(email,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400, fontSize: 14.sp)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Text("Account",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),  Text("Security",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),  Text("Messaging",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),  Text("Privacy",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),  Text("Notifications",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),  Text("Language",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
           Divider(),
            SizedBox(
              height: 15.h,
            ),  Text("About Us",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),Text("Privacy Policy",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),Text("Support",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),
            Divider(),
            SizedBox(
              height: 15.h,
            ),Text("Language",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
            SizedBox(
              height: 15.h,
            ),Text("Dark Mode",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 18.sp)),
          ],
        ),
      ),
    );
  }
}
