import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruiter_app/features/resdex/model/job_response_model.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/resume_service/resume_service.dart';

class ResumeRepository {
  Future<bool?> downloadResume(
      {required int id, retryCount = 0, maxRetries = 3}) async {
    try {
      final response = await ResumeService.downloadResume(id: id);
       Fluttertoast.showToast(
          msg: response.body.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return true;
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return downloadResume(
            id: id, retryCount: retryCount! + 1, maxRetries: maxRetries);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
