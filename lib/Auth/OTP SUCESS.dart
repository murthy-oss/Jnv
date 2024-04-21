import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../components/myButton.dart';


class OTPSUCCESS extends StatefulWidget {




  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPSUCCESS> {
  final TextEditingController _pinPutController = TextEditingController();

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
                child: Transform.scale(
                  scale: 0.6, // Adjust the scale factor as needed
                  child: Image.asset(
                    "Assets/images/verification3.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
    Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Success!",
                  style:
                  GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Congratulations! You have been \n   successfully authenticated!",
                  style:
                  GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w700,color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(onTap: () {
                // Navigator.pushReplacement(
                //   context,
                //   PageRouteBuilder(
                //     transitionDuration: Duration(
                //         milliseconds:
                //         500), // Adjust duration as needed
                //     pageBuilder:
                //         (context, animation, secondaryAnimation) =>
                //         SetUpProfile(),
                //     transitionsBuilder: (context, animation,
                //         secondaryAnimation, child) {
                //       var begin = Offset(0.0, 1.0);
                //       var end = Offset.zero;
                //       var curve = Curves.ease;
                //
                //       var tween =
                //       Tween(begin: begin, end: end).chain(
                //         CurveTween(curve: curve),
                //       );
                //
                //       return SlideTransition(
                //         position: animation.drive(tween),
                //         child: child,
                //       );
                //     },
                //   ),
                // );
              }, text: 'Continue',    color:Color(0xFF888BF4)),
            ),


          ],
        ),
      ),
    );
  }
}