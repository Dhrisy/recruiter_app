import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/view/welcome_screen.dart';
import 'package:recruiter_app/features/plans/data/plan_repository.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class SubscribePlan extends StatelessWidget {
  final int planId;

  SubscribePlan({Key? key, required this.planId}) : super(key: key);

  final TextEditingController _phnCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/svgs/group_circle.svg",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const CommonAppbarWidget(
                        title: "Subscribe",
                        isBackArrow: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter the phone number",
                        style: AppTheme.bodyText(greyTextColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReusableTextfield(
                        controller: _phnCont,
                        keyBoardType: TextInputType.number,
                        lengthLimit: 10,
                        validation: (_) {
                          if (_phnCont.text.trim().isEmpty) {
                            return "This field is required";
                          } else if (_phnCont.text.length < 10) {
                            return "Contact number must contain 10 letters";
                          }
                          return null;
                        },
                        labelText: "Contact number",
                        // isRequired: true,
                      ),
                    ],
                  ),
                  ReusableButton(
                      action: () async {
                        final result = await PlanRepository().subscribePlan(
                            planId: planId,
                            phone: _phnCont.text,
                            transactionId: "hagd");

                        if (result == "success") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              AnimatedNavigation()
                                  .fadeAnimation(WelcomeScreen()), (Route<dynamic> route) => false);
                        }
                      },
                      text: "Subscribe")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
