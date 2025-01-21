import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonAppbarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool? isBackArrow;
  final VoidCallback? action;

  const CommonAppbarWidget(
      {Key? key, required this.title, this.icon, this.isBackArrow, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * 0.09.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 20,
              children: [
                isBackArrow == true
                    ? InkWell(
                            onTap: () {
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
                Text(
                  title,
                  style:
                      theme.textTheme.headlineMedium!.copyWith(fontSize: 20.sp),
                )
                    .animate()
                    .fadeIn(
                        begin: 0.0,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 800))
                    .scale()
              ],
            ),
            icon != null ? InkWell(
              onTap: action ?? (){},
              child: Icon(icon)) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
