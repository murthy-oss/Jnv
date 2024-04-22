class UserModel1 {
  String? userId;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? email;
  String? phoneNumber;
  String? aadharCardNumber;
  String? maritalStatus;
  String? occupation;
  String? section;
  String? state;
  String? district;
  String? schoolCampus;
  String? entryYear;
  String? entryClass;
  String? passOutYear;
  String? house;
  String? profilePicture;
  String? bio;
  String? NavodhyaId;
  String? achievements;
  String? instagramLink;
  String? linkedinLink;
  bool isVerified = false;
  bool showEmail = false;
  bool showPhone = false;
  bool showLinkedin = false;

  UserModel1();

  UserModel1.fromJson(Map<String?, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        dateOfBirth = json['dateOfBirth'],
        gender = json['gender'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        aadharCardNumber = json['aadharCardNumber'],
        maritalStatus = json['maritalStatus'],
        occupation = json['occupation'],
        section = json['section'],
        state = json['state'],
        district = json['district'],
        schoolCampus = json['schoolCampus'],
        entryYear = json['entryYear'],
        entryClass = json['entryClass'],
        passOutYear = json['passOutYear'],
        house = json['house'],
        profilePicture = json['profilePicture'],
        bio = json['bio'],
        NavodhyaId = json['NavodhyaId'],
        achievements = json['achievements'],
        instagramLink = json['instagramLink'],
        linkedinLink = json['linkedinLink'],
        isVerified = json['isVerified'] ?? false,
        showEmail = json['showEmail'] ?? false,
        showPhone = json['showPhone'] ?? false,
        showLinkedin = json['showLinkedin'] ?? false;
}
