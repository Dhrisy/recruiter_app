import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonNodatafoundWidget extends StatelessWidget {
  const CommonNodatafoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            "assets/images/no_result_found.jpg",
            fit: BoxFit.contain,
            height: 100.h,
          ),
          Text(
            "No results found",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: greyTextColor, fontSize: 14.sp),
          )
        ],
      ),
    );
  }
}
