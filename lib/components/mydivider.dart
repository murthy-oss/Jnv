import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class myDivider extends StatelessWidget {
  const myDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              endIndent: 10,
              color: Color.fromARGB(255, 169, 162, 163),
            ),
          ),
          Text(
            "Or continue with social account",
            style:  TextStyle(
                                          fontFamily: 'InterRegular',
                                          color: Color.fromARGB(255, 169, 162, 163),
                                          fontSize: 16.sp,
                                          letterSpacing: 0.3,
                                          fontWeight:FontWeight.w400
                                        ),
          ),
          Expanded(
            child: Divider(
              indent: 10,
              color: Color.fromARGB(255, 169, 162, 163),
            ),
          ),
        ],
      ),
    );
  }
}
