import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelButtonText;
  final String confirmButtonText;
  final Color titleColor;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final double? height;
  final bool isLoading;

  const CommonAlertDialog({
    Key? key,
   required this.title,
   required this.message,
    this.cancelButtonText = 'No',
    this.confirmButtonText = 'Yes',
    this.titleColor = Colors.red,
    required this.onConfirm,
    required this.onCancel,
   required this.height,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 17.sp),
          ),
        ],
      ),
      content: AnimatedContainer(
        duration: 500.ms,
        height: height?.h,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Row(
              spacing: 15,
              children: [
                Expanded(
                  child: ReusableButton(
                    height: 40,
                    textColor: Colors.white,
                    action: onCancel,
                    text: cancelButtonText,
                    buttonColor: secondaryColor,
                  ),
                ),
                Expanded(
                  child: ReusableButton(
                    height: 40,
                    textColor: Colors.white,
                    action: onConfirm,
                    text: confirmButtonText,
                    isLoading: isLoading,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale();
  }
}