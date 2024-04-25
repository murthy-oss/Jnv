import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';

import '../Screen/onboardingProfile/onboardingProfilePage.dart';
import '../components/myButton.dart';


class OTPSUCCESS extends StatefulWidget {




  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPSUCCESS> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:MediaQuery
                  .of(context)
                  .size
                  .width / 3 ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3, // Adjusted height
              width: MediaQuery
                  .of(context)
                  .size
                  .width, // Adjusted height

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  width:150.w,
                  "Assets/images/Successmark.svg",
                  
                  fit: BoxFit.contain,
                ),
              ),
            ),
    Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Success!",
                  style:
                  TextStyle(
                      fontFamily: 'InterRegular',
                      color: Color.fromARGB(255, 65, 65, 65),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Congratulations! You have been \n   successfully authenticated!",
                  style:
                   TextStyle(
                      fontFamily: 'InterRegular',
                      color: Colors.grey,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 14.h,vertical: 10.h),
              child: MyButton(onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds:
                        500), // Adjust duration as needed
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                        SetUpProfile(),
                    transitionsBuilder: (context, animation,
                        secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween =
                      Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              }, text: 'Continue',    color:Colors.black),
            ),


          ],
        ),
      ),
    );
  }
}