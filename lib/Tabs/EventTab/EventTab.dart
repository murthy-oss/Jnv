import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Screen/event_Screen/CreateEvent.dart';
import '../../Screen/event_Screen/Joined_Event.dart';
import '../../Screen/event_Screen/myEvents.dart';
import '../../UI-Models/EventmodelUI.dart';
import '../../Widgets/searchbar.dart';

class EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 200),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0), // Slide from right to left
                    end: Offset.zero,
                  ).animate(animation),
                  child: CreateEventPage(),
                );
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 250),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin:
                                  Offset(1.0, 0.0), // Slide from right to left
                              end: Offset.zero,
                            ).animate(animation),
                            child: MyParticipatedEventsPage(),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 40.h,
                    child: Center(
                        child: Text(
                      'Participated Events',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w500),
                    )),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0), // Slide from right to left
                            end: Offset.zero,
                          ).animate(animation),
                          child: My_events(),
                        );
                      },
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 40.h,
                    child: Center(
                        child: Text(
                      'Created Events',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w500),
                    )),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> eventDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: eventDocs.length,
                    itemBuilder: (context, index) {
                      var eventData =
                          eventDocs[index].data() as Map<String, dynamic>;
                      if (eventData['EventStatus'] == 'Accepted') {
                        return EventUICard(
                          eventName: eventData['eventName'],
                          location: eventData['location'],
                          eventTime: eventData['time'],
                          description: eventData['description'],
                          imageUrl: eventData['imageUrl'],
                          eventType: eventData['eventType'],
                          eventID: eventData['eventID'],
                          userId: eventData['userUid'],
                          eventDate: eventData['datePublished'],
                          EventStatus: eventData['EventStatus'],
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
