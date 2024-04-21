import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String text;
  final dynamic color; // Change type to dynamic
  final void Function()? onTap;

  const MyButton({
    Key? key, // Add Key? key parameter
    required this.onTap,
    required this.text,
    required this.color,
  }) : super(key: key); // Fix constructor

  @override
  Widget build(BuildContext context) {
    Color buttonColor; // Define a variable to hold the final color
    if (color is Color) {
      // Check if the color is of type Color
      buttonColor = color;
    } else if (color is String) {
      // Check if the color is a hexadecimal string
      buttonColor = Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      // Default color
      buttonColor = Colors.blue; // You can change this to any default color you prefer
    }

    return ElevatedButton(
      onPressed: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.width * 0.13,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.aladin(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Use the determined color
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
      ),
    );
  }
}


class MyButton1 extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onTap;

  const MyButton1({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25, // Adjust as needed
        height: 50,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0),
    );
  }
}
