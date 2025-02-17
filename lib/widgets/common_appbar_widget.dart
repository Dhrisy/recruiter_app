import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class CommonAppbarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool? isBackArrow;
  final VoidCallback? action;
  final VoidCallback? backAction;

  const CommonAppbarWidget(
      {Key? key, required this.title, this.icon, this.isBackArrow, this.action, this.backAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.05.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              spacing: 20,
              children: [
                isBackArrow == true
                    ? InkWell(
                            onTap: backAction ?? (){
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 32.sp,
                            ))
                        .animate()
                        .fadeIn(
                            begin: 0.0,
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 800))
                        .scale()
                    : const SizedBox.shrink(),
                Expanded(
                  child: Text(
                    title,
                    style:
                        AppTheme.headingText(lightTextColor),
                  )
                      .animate()
                      .fadeIn(
                          begin: 0.0,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 800))
                      .scale(),
                )
              ],
            ),
          ),
          icon != null
              ? InkWell(
                  onTap: action ?? () {},
                  child: Icon(icon)
                      .animate()
                      .fadeIn(
                          begin: 0.0,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 800))
                      .scale())
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
