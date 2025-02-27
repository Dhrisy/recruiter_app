import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/resdex/data/resume_repository.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';

class ResumeProvider extends ChangeNotifier {
  JobResponseModel? downloadResumes;
  String errorMessage = "";

  Future<bool?> downloadResume(
      {required int id, required BuildContext context}) async {
    try {
      final connectivityResult =
          await CustomFunctions.checkInternetConnection();
      if (connectivityResult == false) {
        CustomFunctions.showNoInternetPopup(context, action: () {
          downloadResume(id: id, context: context);
        });
      }

      final result = await ResumeRepository().downloadResume(id: id);
       Fluttertoast.showToast(
          msg: result.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
