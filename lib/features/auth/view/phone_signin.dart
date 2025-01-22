import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/auth/view/welcome_screen.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class PhoneSignin extends StatefulWidget {
  const PhoneSignin({Key? key}) : super(key: key);

  @override
  State<PhoneSignin> createState() => _PhoneSigninState();
}

class _PhoneSigninState extends State<PhoneSignin> {
  final TextEditingController _phnController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool isResendEnabled = false; // Resend OTP button state
  late Timer _timer;
  int _countdown = 30; // Countdown time in seconds

  bool isPhn = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel(); // Dispose of the timer
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      isResendEnabled = false;
      _countdown = 30; // Reset the countdown
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Consumer<LoginProvider>(builder: (context, provider, child) {
              return Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Phone sign in",
                                    style: GoogleFonts.beVietnamPro(
                                        fontSize: 23.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ReusableTextfield(
                                controller: _phnController,
                                labelText: "Phone",
                                hintText: "Enter your phone number",
                                validation: (_){
                                  if(_phnController.text.trim().isEmpty){
                                    return "Please enter phone number";
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "An OTP will be sent to your phone number"),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              isPhn
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        _buildOtpField(context),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Enter the OTP which is sent to your registered phone"),
                                        Row(
                                          children: [
                                            Text(
                                              _countdown != 0
                                                  ? "Resend OTP in "
                                                  : "Didn't get OTP? ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: greyTextColor),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await provider.mobileLogin(
                                                    phone: _phnController.text
                                                        .trim());
                                              },
                                              child: Text(
                                                _countdown == 0
                                                    ? "Resend OTP"
                                                    : "${_countdown.toString()}s",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: buttonColor),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        ReusableButton(
                          isLoading: provider.isLoading,
                          action: () async {
                            if (_formKey.currentState!.validate()) {
                              if (isPhn == true) {
                                
                                final result = await provider.verifyPhoneOtp(
                                    phone: _phnController.text.trim(),
                                    otp: _otpController.text);

                                if (result) {
                                  Navigator.push(
                                      context,
                                      AnimatedNavigation()
                                          .fadeAnimation(WelcomeScreen()));
                                } else {
                                  CommonSnackbar.show(context,
                                      message: provider.error);
                                }
                              } else {
                                setState(() {
                                  isPhn = true;
                                });
                                final result = await provider.mobileLogin(
                                    phone: _phnController.text.trim());

                                if (result == true) {
                                  _startResendTimer();
                                }
                              }
                            }
                          },
                          text: isPhn ? "Verify OTP" : "Send OTP",
                          height: 40.h,
                          textColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
          )),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return PinCodeTextField(
      controller: _otpController,
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
        borderRadius: BorderRadius.circular(15),
        disabledColor: Colors.white,
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
        setState(() {});
      },
    );
  }
}
