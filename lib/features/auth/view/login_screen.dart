import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/view/otp_screen.dart';
import 'package:recruiter_app/features/auth/view/phone_signin.dart';
import 'package:recruiter_app/features/auth/view/welcome_screen.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pwCont = TextEditingController();
  final TextEditingController _confirmPwCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  late PageController _pageController;
  bool _createPw = false;
  bool _isOtp = false;
  final _createPwFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isVisisble = false;

  final _loginFormKey = GlobalKey<FormState>();
  // String label

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
        child: Scaffold(
        
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Stack(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildLogin(theme: theme),
                        _buildForgotPw(theme: theme)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Widget _buildLogin({required ThemeData theme}) {
    return SizedBox(
      // color: Colors.green,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Text(
                            "Sign in",
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 23.sp, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableTextfield(
                            controller: _emailCont,
                            labelText: "Email",
                            hintText: "Email",
                            validation: (_) {
                              if (_emailCont.text.trim().isEmpty) {
                                return "This field is required";
                              } else if (!isValidEmail(_emailCont.text)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _passWordField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _pwCont,
                            labelText: "Password",
                            validation: (_) {
                              if (_pwCont.text.trim().isEmpty) {
                                return "This field is required";
                              } else if (_pwCont.text.length < 8) {
                                return "Password must contain atleast 8 letters";
                              }
                              return null;
                            },
                          ),
                          // ReusableTextfield(
                          //   controller: _pwCont,
                          //   labelText: "Password",
                          //   validation: (_) {
                          //     if (_pwCont.text.trim().isEmpty) {
                          //       return "This field is required";
                          //     } else if (_pwCont.text.length < 8) {
                          //       return "Password must contain atleast 8 letters";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                               InkWell(
                                  onTap: () async {
                                  Navigator.push(context, 
                                  AnimatedNavigation().slideAnimation(PhoneSignin()));
                                  },
                                  child: Text(
                                    "Use phone number",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: buttonColor),
                                  )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                              InkWell(
                                  onTap: () async {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 550),
                                        curve: Curves.easeInOut);
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: buttonColor),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          const SizedBox(
            height: 150,
          ),
            BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.push(
                    context, AnimatedNavigation().fadeAnimation(const WelcomeScreen()));
                CommonSnackbar.show(context, message: "Successfully logged in");
              } else if (state is AuthFailure) {
                CommonSnackbar.show(context, message: state.error);
              }
            }, builder: (context, state) {
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      ReusableButton(
                        isLoading: state is AuthLoading,
                        action: () {
                          if (_loginFormKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(EmailLoginEvent(
                                email: _emailCont.text, password: _pwCont.text));
                          } else {
                            print("Form validation eror");
                          }
                        },
                        text: "Sign in",
                        buttonColor: buttonColor,
                        height: 40.h,
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't you have an account? "),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign up",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _passWordField({
    required TextEditingController controller,
    required String? Function(String?)? validation,
    required TextInputType keyboardType,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
      validator: validation,
      keyboardType: keyboardType,
      maxLines: 1,
      obscureText: !isVisisble,
      decoration: InputDecoration(
        hintText: "",
        labelText: labelText,
        suffixIcon: InkWell(
            onTap: () {
              setState(() {
                isVisisble = !isVisisble;
              });
            },
            child: Icon(
                isVisisble == false ? Icons.visibility : Icons.visibility_off)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red.shade900)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red.shade900)),
      ),
    );
  }

  Widget _buildForgotPw({required ThemeData theme}) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _otpController = TextEditingController();


    return _createPw == true
        ? _buildCreateNewPassword(context: context, theme: theme)
        : SizedBox(
            // color: Colors.green,
            height: double.infinity,
            width: double.infinity,
            child: Column(
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
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      _pageController
                                          .previousPage(
                                              duration:
                                                  Duration(milliseconds: 550),
                                              curve: Curves.easeInOut)
                                          .then((_) {
                                        setState(() {
                                          _isOtp = false;
                                        });
                                      });
                                    },
                                    child: Icon(Icons.arrow_back)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Forgot password",
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
                              controller: _emailController,
                              labelText: "Email",
                              hintText: "Enter your email address",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    "An OTP will be sent to your registered email"),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            _isOtp == true
                                ? Column(
                                    children: [
                                      _buildOtpField(context),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Enter the OTP which is sent to your registered email address")
                                    ],
                                  )
                                : SizedBox.shrink()
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
                        action: () {
                          if (_isOtp == true) {
                            setState(() {
                              _createPw = true;
                            });
                          } else {
                            setState(() {
                              _isOtp = true;
                            });
                          }
                        },
                        text: _isOtp == true ? "Confirm" : "Send OTP",
                        buttonColor: buttonColor,
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
            ),
          );
  }

  Widget _buildCreateNewPassword(
      {required BuildContext context, required ThemeData theme}) {
    return SizedBox(
      // color: Colors.green,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Form(
                    key: _createPwFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _createPw = false;
                                  _isOtp = false;
                                });
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 550),
                                    curve: Curves.easeInOut);
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Create new password",
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 23.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReusableTextfield(
                          controller: _pwCont,
                          labelText: "Password",
                          
                          validation: (_) {
                            if (_pwCont.text.trim().isEmpty) {
                              return "This field is required";
                            } else if (_pwCont.text.length < 8) {
                              return "Password must contain 8 letters";
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ReusableTextfield(
                          controller: _confirmPwCont,
                          labelText: "Re-enter password",
                          validation: (_) {
                            if (_confirmPwCont.text.trim().isEmpty) {
                              return "This field is required";
                            } else if (_pwCont.text != _confirmPwCont.text) {
                              return "Password doesn't match";
                            }
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 400,
              child: Column(
                children: [
                  ReusableButton(
                    action: () {
                      if (_createPwFormKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                      }
                    },
                    text: "Done",
                    buttonColor: buttonColor,
                    height: 40.h,
                    textColor: Colors.white,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
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
        setState(() {
          _createPw = true;
        });
      },
    );
  }
}
