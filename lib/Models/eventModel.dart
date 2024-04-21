import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class EventModel {
  String name;
  String location;
  String time;
  String description;
  String imageUrl;
  String userUid;
  String EventStatus;
  DateTime datePublished;
  DateTime eventDate; // Add eventDate field
  String eventID;
  String EventType;

  EventModel({
    required this.EventStatus,
    required this.name,
    required this.location,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.userUid,
    required this.eventID,
    required this.eventDate,
    required this.EventType, // Initialize eventDate with the provided date
  }) : datePublished = DateTime.now(); // Initialize datePublished with current date and time

  Map<String, dynamic> toMap() {
    // Format the date and time as per your requirement (date, month, time)
    String formattedDate = DateFormat('dd MMM HH:mm').format(eventDate);

    return {
      'eventName': name,
      'location': location,
      'time': time,
      'description': description,
      'imageUrl': imageUrl,
      'userUid': userUid,
      'datePublished': datePublished.toIso8601String(), // Store date as ISO 8601 string
      'eventDate': formattedDate, // Store formatted event date
      'eventID': eventID,
      'eventType': EventType,
      'EventStatus': EventStatus
    };
  }
}
