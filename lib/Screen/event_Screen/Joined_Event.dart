import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UI-Models/EventmodelUI.dart';

class MyParticipatedEventsPage extends StatefulWidget {
  @override
  _MyParticipatedEventsPageState createState() =>
      _MyParticipatedEventsPageState();
}

class _MyParticipatedEventsPageState extends State<MyParticipatedEventsPage> {
  late User? _currentUser;
  late Stream<QuerySnapshot> _participatedEventsStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      _fetchParticipatedEvents();
    }
  }

  void _fetchParticipatedEvents() {
    print('Fetching participated events for user: ${_currentUser!.uid}');
    _participatedEventsStream = FirebaseFirestore.instance
        .collection('events')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text('Participated Events',style: GoogleFonts.inter(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.06),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _participatedEventsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot> allEventDocs = snapshot.data!.docs;
          List<QueryDocumentSnapshot> participatedEventDocs = allEventDocs.where((doc) {
            var data = doc.data();
            if (data != null && data is Map<String, dynamic>) {
              var participants = data['participants'] as List<dynamic>?; // Cast to List<dynamic> or specific type
              if (participants != null) {
                return participants.any((participant) => participant is Map<String, dynamic> && participant['UserId'] == _currentUser!.uid);
              }
            }
            return false;
          }).toList();

          return ListView.builder(
            itemCount: participatedEventDocs.length,
            itemBuilder: (context, index) {
              var eventData = participatedEventDocs[index].data() as Map<String, dynamic>;

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
            },
          );

        },
      ),
    );
  }
}
