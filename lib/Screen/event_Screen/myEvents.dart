import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UI-Models/EventmodelUI.dart';// Import your EventPost widget or data model

class My_events extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<My_events> {
  late User? _currentUser;
  late Stream<QuerySnapshot> _userEventsStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _fetchUserEvents();
    }
  }

  void _fetchUserEvents() {
    _userEventsStream = FirebaseFirestore.instance
        .collection('events')
        .where('userUid', isEqualTo: _currentUser!.uid)
        .snapshots();

    print('Current User ID: ${_currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text('Hosted Events',style: GoogleFonts.inter(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.06),),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userEventsStream,
        builder: (context, snapshot) {
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
              var eventData = eventDocs[index].data() as Map<String, dynamic>;

              return Column(
                children: [
                  Container(
                      color: Colors.grey[200],
                      child: Text("Event Status- ${eventData['EventStatus']}",style: GoogleFonts.acme(fontSize: 15),)),
                  EventUICard(
                    eventName: eventData['eventName'],
                    location: eventData['location'],
                    eventTime: eventData['time'],
                    description: eventData['description'],
                    imageUrl: eventData['imageUrl'],
                    eventType: eventData['eventType'],
                    eventID: eventDocs[index].id,
                    userId: eventData['userUid'],
                    eventDate: eventData['datePublished'],
                    EventStatus: eventData['EventStatus'],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
