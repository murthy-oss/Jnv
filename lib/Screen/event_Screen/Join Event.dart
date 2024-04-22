import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Adjust the import path for your constants file
import 'package:google_fonts/google_fonts.dart';
import '../../components/myButton.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import '../../utils/utils.dart';
import 'EventForm.dart'; // Adjust the import path for your EventForm

class JoinEvent extends StatefulWidget {
  final String eventName;
  final String location;
  final String time;
  final String description;
  final String imageUrl;
  final String eventType;
  final String eventId;
  final String userId;

  JoinEvent({
    required this.eventName,
    required this.location,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.eventType,
    required this.eventId,
    required this.userId,
  });

  @override
  _JoinEventState createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {
  late User? _currentUser;
  bool _userJoinedEvent = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _checkUserJoinedEvent();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _deleteEvent() async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      if (eventSnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in eventSnapshot.docs) {
          await doc.reference.delete();
          showSnackBar(context, "Event Deleted Successfully");
          Navigator.pop(context);
        }
      } else {
        print('No documents found with eventId: ${widget.eventId}');
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> _checkUserJoinedEvent() async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      if (eventSnapshot.docs.isNotEmpty) {
        DocumentSnapshot eventDoc = eventSnapshot.docs.first;
        List<dynamic> participants = eventDoc['participants'];
        setState(() {
          _userJoinedEvent = participants.any((participant) => participant['UserId'] == _currentUser!.phoneNumber);
        });
      }
    } catch (e) {
      print('Error checking user participation: $e');
    }
  }

  Future<void> _leaveEvent() async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      if (eventSnapshot.docs.isNotEmpty) {
        DocumentSnapshot eventDoc = eventSnapshot.docs.first;
        List<dynamic> participants = eventDoc['participants'];
        participants.removeWhere((participant) => participant['UserId'] == _currentUser!.phoneNumber);
        await eventDoc.reference.update({'participants': participants});
        showSnackBar(context, "You have left the event");
        setState(() {
          _userJoinedEvent = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error leaving event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool createdByCurrentUser = _currentUser != null && _currentUser!.phoneNumber == widget.userId;
print(widget.userId);
print(_currentUser!.phoneNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.eventName,
                      style: GoogleFonts.abrilFatface(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.locationCrosshairs),
                        SizedBox(width: 8.0),
                        Text(widget.location),
                      ],
                    ),
                    SizedBox(height: 13.0),
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.meetup,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.eventType,
                          style: TextStyle(
                            color: widget.eventType == 'Physical Event'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 13.0),
                    Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.clock),
                        SizedBox(width: 8.0),
                        Text(widget.time),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      widget.description,
                    ),
                    SizedBox(height: 12.0),
                    Divider(),
                    Column(
                      children: [
                        Text(
                          createdByCurrentUser ? "1" : (_userJoinedEvent ? "Leave Event" : "Join Event"),
                        ),
                        if (createdByCurrentUser)
                          MyButton(
                            onTap: _deleteEvent,
                            text: "Delete Event",
                            color: Colors.red,
                          )
                        else if (_userJoinedEvent)
                          MyButton(
                            onTap: () => _leaveEvent(),
                            text: "Leave Event",
                            color: Colors.red,
                          )
                        else
                          MyButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventForm(eventId: widget.eventId),
                                ),
                              );
                            },
                            text: "Fill Form to Join Event",
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
