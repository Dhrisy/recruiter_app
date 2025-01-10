import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonAppbarWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool? isBackArrow;
  const CommonAppbarWidget(
      {Key? key, required this.title, this.icon, this.isBackArrow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.09.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          spacing: 20,
          children: [
            isBackArrow == true
                ? InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 32.sp,))
                : const SizedBox.shrink(),
            Text(title,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontSize: 20.sp
            ),)
          ],
        ),
      ),
    );
  }
}
