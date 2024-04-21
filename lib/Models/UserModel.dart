import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String phoneNumber;
  final String aadharCardNumber;
  final String maritalStatus;
  final String occupation;
  final String section;
  final String state;
  final String district;
  final String schoolCampus;
  final String entryYear;
  final String entryClass;
  final String passOutYear;
  final String house;
  final String profilePicture;
  final String bio;
  final String achievements;
  final String instagramLink;
  final String linkedinLink;
  final bool IsVerified;

  UserModel( {
    required this.IsVerified,
    required this.userId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.aadharCardNumber,
    required this.maritalStatus,
    required this.occupation,
    required this.section,
    required this.state,
    required this.district,
    required this.schoolCampus,
    required this.entryYear,
    required this.entryClass,
    required this.passOutYear,
    required this.house,
    required this.profilePicture,
    required this.bio,
    required this.achievements,
    required this.instagramLink,
    required this.linkedinLink,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snapshot.id,
      name: data['name'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      gender: data['gender'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      aadharCardNumber: data['aadharCardNumber'] ?? '',
      maritalStatus: data['maritalStatus'] ?? '',
      occupation: data['occupation'] ?? '',
      section: data['section'] ?? '',
      state: data['state'] ?? '',
      district: data['district'] ?? '',
      schoolCampus: data['schoolCampus'] ?? '',
      entryYear: data['entryYear'] ?? '',
      entryClass: data['entryClass'] ?? '',
      passOutYear: data['passOutYear'] ?? '',
      house: data['house'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      bio: data['bio'] ?? '',
      achievements: data['achievements'] ?? '',
      instagramLink: data['instagramLink'] ?? '',
      linkedinLink: data['linkedinLink'] ?? '',
      IsVerified: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'aadharCardNumber': aadharCardNumber,
      'maritalStatus': maritalStatus,
      'occupation': occupation,
      'section': section,
      'state': state,
      'district': district,
      'schoolCampus': schoolCampus,
      'entryYear': entryYear,
      'entryClass': entryClass,
      'passOutYear': passOutYear,
      'house': house,
      'profilePicture': profilePicture,
      'bio': bio,
      'achievements': achievements,
      'instagramLink': instagramLink,
      'linkedinLink': linkedinLink,
    };
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, name: $name, email: $email, '
        'profilePicture: $profilePicture, dateOfBirth: $dateOfBirth, '
        'phoneNumber: $phoneNumber}';
  }
}
