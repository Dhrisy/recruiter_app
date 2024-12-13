import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';


class ProfileCompletionCard extends StatelessWidget {
const ProfileCompletionCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
          secondaryColor,
          gradientColor

        ])
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text("To start connecting with top talent today!"),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}