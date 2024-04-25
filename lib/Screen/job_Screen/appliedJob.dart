import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UI-Models/JobPostModel.dart';

// Import your custom JobCard widget

class AppliedJobsPage extends StatelessWidget {

final String? CurrentUserUid= FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text(
          'Applied Jobs',
          style: GoogleFonts.aladin(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> jobDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: jobDocs.length,
            itemBuilder: (context, index) {
              var jobData = jobDocs[index].data() as Map<String, dynamic>;
              // Check if this job has any applied candidates
              if (jobData.containsKey('appliedCandidates')) {
                List<dynamic> appliedCandidates = jobData['appliedCandidates'];
                // Check if current user's phone number is in appliedCandidates
                bool userApplied = appliedCandidates.any((candidate) =>
                candidate['UserId'] == CurrentUserUid);
                if (userApplied) {
                  // Use your custom JobCard widget to display the job information
                  return JobUICard(
                    jobTitle: jobData['jobTitle'] ?? "",
                    description: jobData['description'] ?? "",
                    location: jobData['location'] ?? "",
                    salary: jobData['salary'] ?? "",
                    experience: jobData['experience'] ?? "",
                    companyName: jobData['companyName'] ?? "",
                    jobPosted: jobData['jobPosted'] ?? "",
                    skillRequired: jobData['skillsRequired'] ?? "",
                    aboutJob: jobData['aboutJob'] ?? "",
                    aboutCompany: jobData['aboutCompany'] ?? "",
                    whoCanApply: jobData['eligibility'] ?? "",
                    numberOfOpenings: jobData['openings'],
                    JobID: jobData['JobId'] ?? "",
                    JobStatus: jobData['jobStatus'] ?? "",
                  );
                }
              }
              // If no candidates have applied or current user hasn't applied, display a placeholder or empty state
              return Container();
            },
          );
        },
      ),
    );
  }
}
