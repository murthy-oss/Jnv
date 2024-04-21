import'package:flutter/material.dart';
Container buildDot(int index, BuildContext context,currentIndex) {
  return Container(
    height: 10,
    width: currentIndex == index ? 25 : 10,
    margin: EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).primaryColor,
    ),
  );
}
