// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class SearchBar1 extends StatelessWidget {
//   final String hintText;
//   final Function(String) onSearch;
//   final TextEditingController searchController;
//
//   SearchBar1({required this.hintText, required this.onSearch, required this.searchController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.search, color: Colors.blue),
//           SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) => onSearch(value),
//               decoration: InputDecoration(
//                 hintStyle: GoogleFonts.aladin(),
//                 hintText: hintText,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }