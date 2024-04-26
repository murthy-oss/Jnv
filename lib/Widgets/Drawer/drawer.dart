import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Auth/SignUp.dart';
import '../../FetchDataProvider/fetchData.dart';
import '../../Screen/event_Screen/CreateEvent.dart';
import '../../Screen/profile/profilePage.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270.w,
      child: Container(

        decoration: BoxDecoration(
         color: Colors.white
        ),
        child: Consumer<UserFetchController>(
          builder: (context, userFetchController, _) {
            if (userFetchController.isDataFetched) {
              var myUser = userFetchController.myUser;
              return ListView(

                children: [
                  DrawerHeader(
                    padding: EdgeInsets.zero, // Remove default padding
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the CircleAvatar
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(myUser.profilePicture!),
                              radius: 26.r,
                            ),
                          ),
                          Text(
                            myUser.name!,
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3), // Add some space between the name and email
                          Text(
                            myUser.email!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.user),
                        SizedBox(width: 15),
                        Text(
                          'Account',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      print(myUser.phoneNumber);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProfileScreen(uid: myUser.userId.toString());
                      },));
                    },
                  ),
                 SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(Clarity.event_outline_alerted),
                        SizedBox(width: 15),
                        Text(
                          'Create Event',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CreateEventPage();
                      },));
                    },
                  ),
                  SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(Bootstrap.people),
                        SizedBox(width: 15),
                        Text(
                          'Invite Friends',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Share.share('Check out this cool app!');
                    },
                  ),
                  SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.questionCircle),
                        SizedBox(width: 15),
                        Text(
                          'FAQs',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return FAQ_Page();
                      // },));
                    },
                  ),
                  SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(Clarity.help_outline_badged),
                        SizedBox(width: 15),
                        Text(
                          'Help',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return TermsAndConditionsPage();
                      // },));
                    },
                  ),
            SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(Clarity.settings_line),
                        SizedBox(width: 15),
                        Text(
                          'Settings',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return SettingsPage();
                      // },));
                    },
                  ),
            SizedBox(height: 5.h,),
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(PixelArtIcons.logout),
                        SizedBox(width: 15),
                        Text(
                          'Log out',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return SignUpPage();
                      },));
                    },
                  ),
                  Divider(),
                  SizedBox(height: 22.h,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(onPressed: () {

                      }, icon: FaIcon(Bootstrap.sun,color: Colors.red,size: 30,)),
                    ),
                  )
                ],
              );
            } else {
              // Show a loading indicator or placeholder while user data is being fetched
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
