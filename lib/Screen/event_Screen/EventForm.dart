import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/myButton.dart';
class EventForm extends StatefulWidget {
  final String eventId;

  EventForm({required this.eventId});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _educationController = TextEditingController();

  Future<void> _joinEvent() async {
    print(widget.eventId);
    try {
      // Query the collection for the event document where 'eventId' is equal to widget.eventId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming eventId is unique)
        DocumentReference eventRef = querySnapshot.docs.first.reference;

        // Create participant data
        Map<String, dynamic> participantData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'occupation': _occupationController.text,
          'gender': _genderController.text,
          'education': _educationController.text,
          'UserId':FirebaseAuth.instance.currentUser!.phoneNumber.toString()
        };

        // Add participant data to the event document
        await eventRef.update({
          'participants': FieldValue.arrayUnion([participantData]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Applied for the event successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        // Handle case where no document with matching eventId is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying for the event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF888BF4),
        title: Text('Apply for Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: _validatePhone,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _occupationController,
                  decoration: InputDecoration(labelText: 'Occupation'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _educationController,
                  decoration: InputDecoration(labelText: 'Education'),
                ),
                SizedBox(height: 20),
                MyButton1(onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with submission
                    _joinEvent();
                  }
                }, text: "Join Event", color: Color(0xFF888BF4))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
