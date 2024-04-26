import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screen/event_Screen/Join Event.dart';
import '../components/myButton.dart';

class EventUICard extends StatefulWidget {
  final String eventName;
  final String description;
  final String location;
  final String eventDate;
  final String eventTime;
  final String eventType;
  final String eventID;
  final String imageUrl;
  final String userId;
  final String EventStatus; // Add EventStatus parameter

  EventUICard({
    required this.eventName,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.eventTime,
    required this.eventType,
    required this.eventID,
    required this.imageUrl,
    required this.userId,
    required this.EventStatus, // Add this line
  });

  @override
  _EventUICardState createState() => _EventUICardState();
}

class _EventUICardState extends State<EventUICard> {

  @override
  Widget build(BuildContext context) {
    // Check if the EventStatus is 'Accepted'
    print(widget.eventID);
    // if (widget.EventStatus == 'Accepted') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Container(height: 90.h,width: 90.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),image: DecorationImage(image: CachedNetworkImageProvider(widget.imageUrl))),)
                ,SizedBox(width: 50.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.eventName,style: GoogleFonts.inter(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                    Text(widget.eventType,style: GoogleFonts.inter(fontWeight: FontWeight.w600,fontSize: 12.sp)),
                    Text("${widget.eventTime} PM",style: GoogleFonts.inter(fontWeight: FontWeight.w400,fontSize: 14.sp)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.0),


            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: MyButton1(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return JoinEvent(
                              eventName: widget.eventName,
                              location: widget.location,
                              time: widget.eventTime,
                              description: widget.description,
                              imageUrl: widget.imageUrl,
                              eventType: widget.eventType,
                              eventId: widget.eventID,
                              userId: widget.userId,
                            );
                          },
                        ),
                      );
                    },
                    text: "View Details",
                    color:Colors.red,
                  ),
                ),

              ],
            ),
          ],
        ),
      );
    // }
    //
    // else {
    //   // If EventStatus is not 'Accepted', return an empty container
    //   return Container(
    //     child: Center(
    //       child: Text('No Events Found'),
    //     ),
    //   );
    // }
  }
}
