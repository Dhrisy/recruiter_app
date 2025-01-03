import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.w;
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.45,
              child: SvgPicture.asset(
                "assets/svgs/onboard_1.svg",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      const SizedBox(
                        width: 40,
                      ),
                      Text(
                        "Resdex",
                        style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    spacing: 15,
                    children: [
                      Row(
                        spacing: 10.w,
                        children: [
                          Expanded(
                              child:
                                  _buildOptionContainer(title: "Search CV's")),
                          Expanded(
                              child: _buildOptionContainer(
                                  title: "Application Response")),
                          Expanded(
                              child: _buildOptionContainer(
                                  title: "Interview Scheduled"))
                        ],
                      ),
                      Row(
                        spacing: 10.w,
                        children: [
                          Expanded(
                              child:
                                  _buildOptionContainer(title: "Saved CV's")),
                          Expanded(
                              child: _buildOptionContainer(
                                  title: "Saved searches")),
                          Expanded(
                              child: _buildOptionContainer(
                                  title: "Email templates"))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionContainer({required String title}) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              title,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    );
  }
}
