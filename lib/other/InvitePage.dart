import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Invite Friends",
            style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          )),
      body: Column(
        children: [
          SvgPicture.asset(
height:380.h,
            'Assets/images/invite.svg',

            fit: BoxFit.contain,
          ),

          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blueAccent[700],
              child: Column(children: [
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: 'Invite',
                            style: GoogleFonts.inter(
                                fontSize: 30.sp, fontWeight: FontWeight.bold))),
                    SizedBox(
                      width: 10.w,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Friends',
                            style: GoogleFonts.inter(
                                fontSize: 30.sp, fontWeight: FontWeight.w400))),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RichText(
                      text: TextSpan(
                          text: 'JNV Diaries',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp, fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: 10.w,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'is way more fun with friends',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp, fontWeight: FontWeight.w400))),
                ]),
                RichText(
                    text: TextSpan(
                        text: 'around. Invite yoyr friends with your invite',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp, fontWeight: FontWeight.w400))),
                RichText(
                    text: TextSpan(
                        text: 'link below',
                        style: GoogleFonts.inter(
                            fontSize: 14.sp, fontWeight: FontWeight.w400))),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Container(
                    height: 50.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your invite link',
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Text('0xggdthg006gdbhdbcs3637g...,,..',
                                      style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white)),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(onPressed: () {
                                    Clipboard.setData(ClipboardData(text: "J.N.V/0xggdthg006gdbhdbcs3637g...,,.."));
                                    // Show a toast or snackbar to indicate that the text has been copied
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Text copied to clipboard")),
                                    );
                                  }, icon: FaIcon(Icons.copy,color: Colors.white,)),
                                  IconButton(onPressed: () {
                                    Share.share('0xggdthg006gdbhdbcs3637g...,,..');
                                  }, icon: FaIcon(Icons.share,color: Colors.white,)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
