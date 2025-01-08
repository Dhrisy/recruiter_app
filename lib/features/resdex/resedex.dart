import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/resdex/widgets/search_cv_form_widget.dart';

class Resedex extends StatefulWidget {
  const Resedex({Key? key}) : super(key: key);

  @override
  State<Resedex> createState() => _ResedexState();
}

class _ResedexState extends State<Resedex> {
  int currentScreenIndex = 0;

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
              child: SingleChildScrollView(
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
                                child: _buildOptionContainer(
                                    title: "Search CV's", index: 0)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Application Response", index: 1)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Schedule Interview ", index: 2))
                          ],
                        ),
                        Row(
                          spacing: 10.w,
                          children: [
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Saved CV's", index: 3)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Saved searches", index: 4)),
                            Expanded(
                                child: _buildOptionContainer(
                                    title: "Email templates", index: 5))
                          ],
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //  serach cv form
                    currentScreenIndex == 0
                        ? SearchCvFormWidget()
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionContainer({required String title, required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          currentScreenIndex = index;
        });
      },
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
            color: currentScreenIndex == index ? buttonColor : Colors.white,
            border: Border.all(
              color: currentScreenIndex == index
                  ? Colors.transparent
                  : secondaryColor,
            ),
            borderRadius: BorderRadius.circular(10.r)),
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
      ),
    );
  }
}
