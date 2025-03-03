import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/auth/view/welcome_screen.dart';
import 'package:recruiter_app/features/plans/data/plan_repository.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class SubscribePlan extends StatefulWidget {
  final int planId;

  SubscribePlan({Key? key, required this.planId}) : super(key: key);

  @override
  State<SubscribePlan> createState() => _SubscribePlanState();
}

class _SubscribePlanState extends State<SubscribePlan> {
  final TextEditingController _phnCont = TextEditingController();
  final TextEditingController _otpCont = TextEditingController();

  bool _isLoading = false;

  bool isSentOtp = false;

  final _formKey = GlobalKey<FormState>();

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
                  Consumer<LoginProvider>(builder: (context, provider, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
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
                            readOnly: isSentOtp,
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
                          const SizedBox(
                            height: 15,
                          ),
                          isSentOtp == true
                              ? ReusableTextfield(
                                  controller: _otpCont,
                                  keyBoardType: TextInputType.number,
                                  lengthLimit: 4,
                                  validation: (_) {
                                    if (_otpCont.text.trim().isEmpty) {
                                      return "This field is required";
                                    } else if (_otpCont.text.length < 4) {
                                      return "Contact number must contain 4 letters";
                                    }
                                    return null;
                                  },
                                  hintText: "Enter OTP",
                                  // isRequired: true,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableButton(
                            isLoading: _isLoading,
                            action: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (isSentOtp == true) {
                                  final subscribed = await PlanRepository()
                                      .subscribePlan(
                                          planId: widget.planId,
                                          phone: _phnCont.text,
                                          transactionId: "hagd");

                                  if (subscribed == "success") {
                                    final result =
                                        await provider.verifyPhoneOtp(
                                            phone: _phnCont.text,
                                            otp: _otpCont.text);
                                    if (result == "success") {
                                       Navigator.pushAndRemoveUntil(
                                          context,
                                          AnimatedNavigation()
                                              .fadeAnimation(WelcomeScreen()),
                                          (Route<dynamic> route) => false);

                                      CommonSnackbar.show(context,
                                          message:
                                              "Successfully verified & subscribed");
                                    } else {
                                     
                                      CommonSnackbar.show(context,
                                          message:
                                               result.toString());
                                     
                                    }
                                  } else {
                                    
                                    CommonSnackbar.show(context,
                                        message: subscribed.toString());
                                  }
                                } else {
                                  final result = await provider.retryOTP(
                                      phone: _phnCont.text);
                                  if (result != null && result == "success") {
                                    setState(() {
                                      isSentOtp = true;
                                      _isLoading = false;
                                    });
                                    CommonSnackbar.show(context,
                                        message: "Otp sent successfully");
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    CommonSnackbar.show(context,
                                        message: result.toString());
                                  }
                                }
                              }
                            },
                            text: isSentOtp == true
                                ? "Verify OTP & Subscribe"
                                : "Sent OTP",
                            textColor: Colors.white,

                            // buttonColor: _phnCont.text.trim().isEmpty || _otpCont.text.trim().isEmpty ? buttonColor.withValues(alpha: 0.3) : buttonColor,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
