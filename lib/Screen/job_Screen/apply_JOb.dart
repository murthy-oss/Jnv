import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/myTextfield.dart';

class ApplyJobPage extends StatefulWidget {
  final String jobId;

  ApplyJobPage({required this.jobId});

  @override
  _ApplyJobPageState createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _resumeController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  TextEditingController _githubController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _portfolioController = TextEditingController();
  TextEditingController _educationController = TextEditingController();



  Future<void> _joinJob() async {
    try {
      QuerySnapshot jobSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('JobId', isEqualTo: widget.jobId)
          .get();

      if (jobSnapshot.docs.isNotEmpty) {
        DocumentSnapshot jobDoc = jobSnapshot.docs.first;

        String currentUserName = _nameController.text;
        String currentUserEmail = _emailController.text;
        String currentUserPhone = _phoneController.text;
        String currentUserResume = _resumeController.text;
        String currentUserLinkedIn = _linkedinController.text;
        String currentUserGithub = _githubController.text;
        String currentUserDescription = _descriptionController.text;
        String currentUserExperience = _experienceController.text;
        String currentUserSkills = _skillsController.text;
        String currentUserPortfolio = _portfolioController.text;
        String currentUserEducation = _educationController.text;

        Map<String, dynamic> candidateData = {
          'name': currentUserName,
          'email': currentUserEmail,
          'phone': currentUserPhone,
          'resume': currentUserResume,
          'linkedin': currentUserLinkedIn,
          'github': currentUserGithub,
          'description': currentUserDescription,
          'experience': currentUserExperience,
          'skills': currentUserSkills,
          'portfolio': currentUserPortfolio,
          'education': currentUserEducation,
          'UserId': FirebaseAuth.instance.currentUser!.uid,
        };

        // Add candidate data to the appliedCandidates array using FieldValue.arrayUnion
        await jobDoc.reference.update({
          'appliedCandidates': FieldValue.arrayUnion([candidateData])
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Applied for the job successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        print('No job found with ID: ${widget.jobId}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying for the job: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Apply for Job'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Other TextFormFields...

                MyTextField(
                  controller: _nameController,
                  hint: 'Name',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.drive_file_rename_outline,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.email,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _phoneController,
                  hint: 'Phone Numner',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.phone,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  hint: 'About Candidate',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.abc_outlined,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _experienceController,
                  hint: 'Experience',
                  keyboardtype: TextInputType.datetime,
                  preIcon: Icons.abc_outlined,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _resumeController,
                  hint: 'Resume Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,

                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _linkedinController,
                  hint: 'LinkedIn Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,

                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _githubController,
                  hint: 'GitHub Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,

                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _portfolioController,
                  hint: 'Portfolio Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,

                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {

                      _joinJob();
                    
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
