import 'package:flutter/material.dart';

class MyContainer extends StatefulWidget {
  final String Imgurl;
  final String title;
  const MyContainer({Key? key, required this.Imgurl, required this.title}) : super(key: key);

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.width / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          // Image with blend mode
          Positioned.fill(
            child: Image.asset(
              widget.Imgurl,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.srcOver,
              color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
            ),
          ),
          // Title at the center
          Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyContainer1 extends StatefulWidget {
  final String Imgurl;
  final String title;
  const MyContainer1({Key? key, required this.Imgurl, required this.title}) : super(key: key);

  @override
  State<MyContainer1> createState() => _MyContainer1State();
}

class _MyContainer1State extends State<MyContainer1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.width / 1.75, // Adjusted height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          // Image with blend mode
          Positioned.fill(
            child: Image.asset(
              widget.Imgurl,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.srcOver,
              color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
            ),
          ),
          // Title at the center
          Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
