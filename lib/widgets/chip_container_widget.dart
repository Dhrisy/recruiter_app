import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class ChipContainerWidget extends StatelessWidget {
  final String text;
  final bool? icon;
  final VoidCallback? action;
  final Color? color;
  final Color? textColor;
  final Duration? duration;
  const ChipContainerWidget(
      {Key? key, required this.text, this.icon, this.action, this.color,
      this.textColor, this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color != null ?  color! : buttonColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // spacing: 4.w,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor ?? lightTextColor
            ),
          ),
        icon != null ?  GestureDetector(
            onTap: action ?? (){},
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: greyTextColor,
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    ).animate().fadeIn(duration: duration ?? 500.ms).scale();
  }
}
