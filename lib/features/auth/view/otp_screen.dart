import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/auth/provider/register_provider.dart';
import 'package:recruiter_app/features/auth/view/welcome_screen.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/features/plans/viewmodel/plan_provider.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class OtpScreen extends StatefulWidget {
  final PageController? controller;
  final String? phone;
  final String? email;
  final bool isRegistering;
  final int? planId;
  const OtpScreen(
      {Key? key,
      this.controller,
      this.phone,
      this.email,
      this.planId,
      required this.isRegistering})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _remainingTime = 30;
  final TextEditingController _otpCont = TextEditingController();
  final _otpFormKey = GlobalKey<FormState>();

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
    return Material(
      child: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _otpFormKey,
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
                                  if (widget.controller != null) {
                                    widget.controller!.previousPage(
                                        duration: Duration(milliseconds: 550),
                                        curve: Curves.easeInOut);
                                  }
                                },
                                child: Icon(Icons.arrow_back)),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "OTP Verification",
                              style: AppTheme.headingText(lightTextColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "We have send a verification code to ${widget.phone != null ? "+91${widget.phone}" : widget.email != null ? "${widget.email}" : ""}",
                          style: AppTheme.bodyText(lightTextColor).copyWith(fontSize: 12.sp
                          ),
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
                              style: AppTheme.bodyText(buttonColor)
                            ),
                            Text(
                              "number..?",
                              style: AppTheme.bodyText(lightTextColor),
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
                                style: AppTheme.bodyText(lightTextColor)
                              ),
                              Text(
                                " 00:${_remainingTime.toString().padLeft(2, '0')}",
                                textAlign: TextAlign.center,
                                style: AppTheme.bodyText(buttonColor)
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
                                style: AppTheme.bodyText(lightTextColor)
                              ),
                              InkWell(
                                onTap: () async{
                                await  Provider.of<RegisterProvider>(context, listen: false).retryOTP(
                                                          phn: widget.phone.toString());
                                },
                                child: Text(
                                  " OTP",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyText(buttonColor),
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
                ),
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                  if (state is OtpVerified && widget.isRegistering == true) {
                    _showAlertDialogue(context);
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(context,
                          AnimatedNavigation().fadeAnimation(Questionaire1()));
                    });
                  } else if (state is OtpVerified &&
                      widget.isRegistering == false) {
                    Navigator.push(context,
                        AnimatedNavigation().fadeAnimation(WelcomeScreen()));
                  }

                  if (state is OtpVerifiedFailed) {
                    CommonSnackbar.show(context, message: state.error);
                  }
                }, builder: (context, state) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ReusableButton(
                        isLoading: state is AuthLoading,
                        action: () async {
                          if (_otpFormKey.currentState!.validate()) {
                            if (widget.phone != null && widget.planId != null) {
                              final result = await Provider.of<PlanProvider>(
                                      context,
                                      listen: false)
                                  .subscribePlan(
                                      planId: widget.planId!,
                                      phone: widget.phone!,
                                      transactionId: "transactionId");

                              if (result == "success") {
                                context.read<AuthBloc>().add(
                                    MobileOtpVerifyEvent(
                                        phone: widget.phone!,
                                        otp: _otpCont.text));
                              }
                            } else if (widget.email != null) {
                              context.read<AuthBloc>().add(EmailOtpVerifyEVent(
                                  otp: _otpCont.text,
                                  email: widget.email.toString()));
                            }
                          }

                          // _showAlertDialogue(context);
                          // Future.delayed(Duration(seconds: 1), (){
                          //   Navigator.push(context, AnimatedNavigation().fadeAnimation(Questionaire1()));
                          // });
                        },
                        text: "Confirm",
                        width: 200.w,
                        radius: 30.r,
                        textColor: Colors.white,
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return PinCodeTextField(
      controller: _otpCont,
      appContext: context,
      validator: (_) {
        if (_otpCont.text.trim().isEmpty) {
          return "This field is required";
        }
        return null;
      },
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
