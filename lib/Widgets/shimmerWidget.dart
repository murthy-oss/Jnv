import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShimmerPostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            height: 50.0,
            width: double.infinity,
          ),
          SizedBox(height: 8.0),
          Container(
            height: MediaQuery.of(context).size.width / 1.75,
            color: Colors.grey[200],
          ),
          SizedBox(height: 8.0),
          Container(
            color: Colors.grey[200],
            height: 50.0,
            width: double.infinity,
          ),
          SizedBox(height: 8.0),
          Container(
            color: Colors.grey[200],
            height: 20.0,
            width: double.infinity,
          ),
          SizedBox(height: 8.0),
          Container(
            color: Colors.grey[200],
            height: 20.0,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}