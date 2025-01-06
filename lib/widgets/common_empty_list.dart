import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';

class CommonEmptyList extends StatelessWidget {
  const CommonEmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      // height: 400,
      width: double.infinity,
      child: Column(
        children: [
         
          Image.asset("assets/images/empty_pic.png"),
          const SizedBox(
            height: 15,
          ),
          Text("No data available",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: greyTextColor
          ),
          )
        ],
      ),
    );
  }
}
