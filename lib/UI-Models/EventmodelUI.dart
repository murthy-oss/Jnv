import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      return Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.eventName,
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ), Text(
                    "Price 0\$",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.description,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 4.0),
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Colors.green),
                  SizedBox(width: 4.0),
                  Text(
                    '${widget.eventDate}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
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
                      color:Color(0xFF888BF4),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.eventType,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget.eventType == "Virtual Event"
                            ? Colors.green
                            : Colors.purple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
