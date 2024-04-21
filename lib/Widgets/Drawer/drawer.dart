// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:icons_plus/icons_plus.dart';
//
// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//
//       width: 250,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF888BF4), Colors.white30],
//           ),
//         ),
//         child: Consumer<UserFetchController>(
//           builder: (context, userFetchController, _) {
//             if (userFetchController.isDataFetched) {
//               var myUser = userFetchController.myUser;
//               return ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: CachedNetworkImageProvider(myUser.profilePhotoUrl!),
//                           radius: MediaQuery.of(context).size.width * 0.085,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           myUser.name!,
//                           style: GoogleFonts.aladin(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           myUser.email!,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             fontSize: MediaQuery.of(context).size.width * 0.027,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.user),
//                         SizedBox(width: 15),
//                         Text(
//                           'Account',
//                           style: GoogleFonts.aladin(
//                             fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       print(myUser.phoneNumber);
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return ProfileScreen(uid: myUser.userId.toString());
//                       },));
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesome.joget_brand),
//                         SizedBox(width: 15),
//                         Text(
//                           'Create Job',
//                           style: GoogleFonts.aladin(
//                             fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return JobPostingPage();
//                       },));
//                     },
//                   ),  Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(Clarity.event_outline_alerted),
//                         SizedBox(width: 15),
//                         Text(
//                           'Create Event',
//                           style: GoogleFonts.aladin(
//                             fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return CreateEventPage();
//                       },));
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.peopleGroup),
//                         SizedBox(width: 15),
//                         Text(
//                           'Invite Friends',
//                           style: GoogleFonts.aladin(
//                               fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Share.share('Check out this cool app!');
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.questionCircle),
//                         SizedBox(width: 15),
//                         Text(
//                           'FAQs',
//                           style: GoogleFonts.aladin(
//                               fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return FAQ_Page();
//                       },));
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.question),
//                         SizedBox(width: 15),
//                         Text(
//                           'Help',
//                           style: GoogleFonts.aladin(
//                               fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return TermsAndConditionsPage();
//                       },));
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.gear),
//                         SizedBox(width: 15),
//                         Text(
//                           'Settings',
//                           style: GoogleFonts.aladin(
//                               fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return SettingsPage();
//                       },));
//                     },
//                   ),
//                   Divider(),
//                   ListTile(
//                     title: Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.signOutAlt),
//                         SizedBox(width: 15),
//                         Text(
//                           'Log Out',
//                           style: GoogleFonts.aladin(
//                               fontSize: MediaQuery.of(context).size.width * 0.05
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//                         return SignUpPage();
//                       },));
//                     },
//                   ),
//                 ],
//               );
//             } else {
//               // Show a loading indicator or placeholder while user data is being fetched
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
