import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
class myDivider extends StatelessWidget {
  const myDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            endIndent: 10,
            color: Colors.black,
          ),
        ),
        Text(
          "OR",
          style: GoogleFonts.poppins(
              fontSize: width * 0.05, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Divider(
            indent: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
