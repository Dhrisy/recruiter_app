import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';
import 'package:recruiter_app/features/resdex/model/seeker_model.dart';

class ResumeModel {
  final SeekerPersonalModel? seekerData;
  // final JobPostModel jobData;


  ResumeModel({
    // required this.jobData,
    required this.seekerData
  });


  factory ResumeModel.fromJson(Map<String, dynamic> json){
  //   Fluttertoast.showToast(
  //   msg: json["job"].toString(),

  //   toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
  //   gravity: ToastGravity.BOTTOM, // Position: TOP, CENTER, BOTTOM
  //   backgroundColor: Colors.black,
  //   textColor: Colors.white,
  //   fontSize: 16.0,
  // );

    return ResumeModel(
      seekerData: SeekerPersonalModel.fromJson(json["candidate"]),
        // jobData: JobPostModel.fromJson(json["job"])
    );
  }
}


