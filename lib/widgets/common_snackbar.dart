import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = const Color.fromARGB(255, 74, 73, 73),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: borderColor,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
          
        ),
        elevation: 0,

        backgroundColor: backgroundColor ,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
