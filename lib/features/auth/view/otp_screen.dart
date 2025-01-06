import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class OtpScreen extends StatefulWidget {
  final PageController controller;
  final String phone;
  const OtpScreen({Key? key, required this.controller, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _remainingTime = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     const SizedBox(
                height: 40,
              ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              widget.controller.previousPage(
                                  duration: Duration(milliseconds: 550),
                                  curve: Curves.easeInOut);
                            },
                            child: Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "OTP Verification",
                          style: theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 23.sp),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "We have send a verification code to the mobile number +91${widget.phone}",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Change ",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: buttonColor),
                        ),
                        Text(
                          "number..?",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildOtpField(context),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_remainingTime != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Resend OTP in ",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            " 00:${_remainingTime.toString().padLeft(2, '0')}",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: buttonColor),
                          ),
                        ],
                      ),
                    if (_remainingTime == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? Resend",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              " OTP",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: buttonColor),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ReusableButton(
                    action: () {
                      _showAlertDialogue(context);
                      // Future.delayed(Duration(seconds: 1), (){
                      //   Navigator.push(context, AnimatedNavigation().fadeAnimation(Questionaire1()));
                      // });
                    },
                    text: "Confirm",
                    buttonColor: buttonColor,
                    width: 200.w,
                    radius: 30.r,
                    textColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      errorTextSpace: 0,
      length: 4,
      keyboardType: TextInputType.number,

      textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      enableActiveFill: true,
      showCursor: true,
      obscureText: false,
      autoUnfocus: true,
      cursorColor: buttonColor,
      cursorHeight: 25,
      pinTheme: PinTheme(
        fieldWidth: 50,
        borderWidth: 0.3,
        borderRadius: BorderRadius.circular(15), // Rounded corners
        shape: PinCodeFieldShape.box,
        activeColor: buttonColor,
        inactiveColor: greyTextColor,
        selectedColor: buttonColor,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
      ),
      onChanged: (value) => {},
      // controller: _otpController,
      onCompleted: (value) async {
        FocusScope.of(context).unfocus();
      },
    );
  }

  void _showAlertDialogue(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SvgPicture.asset("assets/svgs/success_image.svg"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'Congratulations!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: buttonColor),
                    children: [
                      TextSpan(
                        text: ' You have been succesfully authenticated ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
