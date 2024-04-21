import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessWidget extends StatefulWidget {
  final String text1;
  final String text2;
  SuccessWidget({ required this.text1, required this.text2});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<SuccessWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }



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
                  "${widget.text1 }\n   ${widget.text2}",
                  style:
                  GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w700,color: Colors.grey),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}