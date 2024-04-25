import'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Container buildDot(int index, BuildContext context,currentIndex) {
  return Container(
    height: 10.h,
    width:  10.w,
    margin: EdgeInsets.only(right: 6.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color.fromARGB(255, 27, 28, 30)
      ),
      color: currentIndex == index ?const Color.fromARGB(255, 27, 28, 30):Colors.white
    ),
  );
}
