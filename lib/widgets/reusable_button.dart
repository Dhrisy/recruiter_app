import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class ReusableButton extends StatefulWidget {
  final VoidCallback action;
  final double? height;
  final double? width;
  final String text;
  final IconData? icon;
  final double? radius;
  final Color buttonColor;
  final Color? textColor;
  final double? textSize;
  const ReusableButton(
      {Key? key,
      required this.action,
      this.height,
      required this.text,
      this.icon,
      this.width,
      this.radius,
      required this.buttonColor,
      this.textSize,
      this.textColor})
      : super(key: key);

  @override
  _ReusableButtonState createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.radius ?? 15.r),
      onTap: widget.action,
      child: Container(
        height: widget.height ?? 45.h,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.radius ?? 15.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: AppTheme.bodyText(widget.textColor ?? lightTextColor)
                  .copyWith(fontSize: widget.textSize ?? mediumSmallFont),
            )
          ],
        ),
      ),
    );
  }
}
