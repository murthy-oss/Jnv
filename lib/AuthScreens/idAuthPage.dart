import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdAuthPagState extends StatefulWidget {
  const IdAuthPagState({super.key});

  @override
  State<IdAuthPagState> createState() => _IdAuthPagStateState();
}

class _IdAuthPagStateState extends State<IdAuthPagState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [ 
          SvgPicture.asset('Assets/images/idAuth.svg')
        ],
      ),
    );
  }
}