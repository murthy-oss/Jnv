import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JobDetailModel extends StatefulWidget {
  final String jobTitle;
  final String description;
  final String location;
  final String salary;
  final String experience;
  final String companyName;
  final String jobPosted;
  final String skillRequired;
  final String aboutJob;
  final String aboutCompany;
  final String whoCanApply;
  final String JobID;
  final int numberOfOpenings;

  const JobDetailModel({
    required this.jobTitle,
    required this.description,
    required this.location,
    required this.salary,
    required this.experience,
    required this.companyName,
    required this.jobPosted,
    required this.skillRequired,
    required this.aboutJob,
    required this.aboutCompany,
    required this.whoCanApply,
    required this.JobID,
    required this.numberOfOpenings,
  });

  @override
  State<JobDetailModel> createState() => _JobDetailModelState();
}

class _JobDetailModelState extends State<JobDetailModel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.jobTitle,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888BF4),
                ),
              ),
              Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.description,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.location_on, color: Color(0xFF888BF4)),
              SizedBox(width: 5.0),
              Text(
                widget.location,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.attach_money, color: Color(0xFF888BF4)),
              SizedBox(width: 5.0),
              Text(
                widget.salary,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.timer, color: Color(0xFF888BF4)),
              SizedBox(width: 5.0),
              Text(
                widget.experience,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.building, color: Color(0xFF888BF4)),
              SizedBox(width: 5.0),
              Text(
                widget.companyName,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Posted ${widget.jobPosted} ago',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            "About ${widget.companyName}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF888BF4),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.aboutCompany,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            "About The Job",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF888BF4),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.aboutJob,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            "Skills Required",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF888BF4),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.skillRequired,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            "Who Can Apply",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF888BF4),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.whoCanApply,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            "Number of Openings",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF888BF4),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.numberOfOpenings.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.all(15.0),
        ),
      ],
    );
  }
}
