import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/widgets/loading_widget.dart';

class ReusableButton extends StatefulWidget {
  final VoidCallback action;
  final double? height;
  final double? width;
  final String text;
  final Widget? iconWidget;
  final double? radius;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final bool? isLoading;
  final Color? borderColor;
  const ReusableButton(
      {Key? key,
      required this.action,
      this.height,
      required this.text,
      this.iconWidget,
      this.width,
      this.radius,
       this.buttonColor,
      this.textSize,
      this.textColor,
      this.borderColor,
      this.isLoading})
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
            color: widget.buttonColor ?? buttonColor,
            border: Border.all(
              color: widget.borderColor ?? Colors.transparent
            ),
            borderRadius: BorderRadius.circular(widget.radius ?? 15.r),

            gradient: widget.buttonColor != null 
            ? null
            :   LinearGradient(colors: [buttonColor, Color(0xffFF582B)])
            ),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isLoading == true
                ? LoadingWidget(
                  color: Colors.white,
                )
                : Expanded(
                  child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.bodyText(widget.textColor ?? lightTextColor)
                          .copyWith(fontSize: widget.textSize ?? mediumSmallFont),
                    ),
                ),

                  widget.iconWidget != null
                  ? widget.iconWidget! : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
