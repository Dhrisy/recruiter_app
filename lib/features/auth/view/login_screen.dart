import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/auth/view/otp_screen.dart';
import 'package:recruiter_app/features/auth/view/phone_signin.dart';
import 'package:recruiter_app/features/auth/view/register.dart';
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
  final TextEditingController _emailCont = TextEditingController();

  final TextEditingController _phnController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late PageController _pageController;
  bool _createPw = false;
  bool _isOtp = false;
  final _createPwFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isVisisble = false;

  bool hasEightChars = false;
  bool hasUppercase = false;
  bool hasSpecialChar = false;
  bool hasNumber = false;
  bool hasSmallLetter = false;
  bool isMatch = true;

  final _loginFormKey = GlobalKey<FormState>();
  final _forgotPwFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  // String label

  void _validatePassword(String password) {
    setState(() {
      hasEightChars = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSmallLetter = password.contains(RegExp(r'[a-z]'));
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  // @override
  // void dispose() {
  //   // _pwCont.dispose();
  //   _confirmPwCont.dispose();
  //   // _emailCont.dispose();
  //   _phnController.dispose();
  //   _otpController.dispose();
  //   // _pageController.dispose();
  //   super.dispose();
  // }

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

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('This is a simple alert dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('CANCEL'),
            ),
            BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
              if (state is GetOtpSuccess) {
                Navigator.push(
                    context,
                    AnimatedNavigation().slideAnimation(OtpScreen(
                      isRegistering: false,
                      email: _emailCont.text,
                    )));
                CommonSnackbar.show(context, message: "OTP sent successfully");
              }

              if (state is GetOtpFailure) {
                CommonSnackbar.show(context, message: state.error);
              }
            }, builder: (context, state) {
              return TextButton(
                onPressed: () async {
                  context
                      .read<AuthBloc>()
                      .add(EmailSentOtpEvent(email: _emailCont.text));
                },
                child: Text('Verify email'),
              );
            }),
          ],
        );
      },
    );
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
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        AnimatedNavigation()
                                            .slideAnimation(ForgotPassWord()));
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
                Navigator.pushAndRemoveUntil(
                    context,
                    AnimatedNavigation().fadeAnimation(const WelcomeScreen()),
                    (Route<dynamic> route) => false);
                CommonSnackbar.show(context, message: "Successfully logged in");
              } else if (state is AuthFailure) {
                CommonSnackbar.show(context, message: state.error);
              } else if (state is EmailVerifyNeeded) {
                _showAlertDialog(context);
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
                                email: _emailCont.text,
                                password: _pwCont.text));
                          } else {
                            print("Form validation eror");
                          }
                        },
                        text: "Sign in",
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
                                Navigator.push(
                                    context,
                                    AnimatedNavigation()
                                        .slideAnimation(Register()));
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
}

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({Key? key}) : super(key: key);

  @override
  _ForgotPassWordState createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _confirmPwCont = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phnController = TextEditingController();
  final _forgotPwFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _createPwFormKey = GlobalKey<FormState>();

  bool hasEightChars = false;
  bool hasUppercase = false;
  bool hasSpecialChar = false;
  bool hasNumber = false;
  bool hasSmallLetter = false;
  bool isMatch = true;

  void _validatePassword(String password) {
    setState(() {
      hasEightChars = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSmallLetter = password.contains(RegExp(r'[a-z]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        body: Consumer<LoginProvider>(builder: (context, provider, child) {
          return Form(
            key: _forgotPwFormKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Column(
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
                                        provider.setOtpSuccess(false);
                                        _phnController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Forgot password",
                                    style: GoogleFonts.beVietnamPro(
                                        fontSize: 23.sp, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              provider.otpSuccess == false
                                  ? Column(
                                      children: [
                                        ReusableTextfield(
                                          controller: _phnController,
                                          labelText: "Phone number",
                                          hintText: "Enter your phone",
                                          validation: (_) {
                                            if (_phnController.text.trim().isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("An OTP will be sent to your phone"),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _buildOtpField(context),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Enter the OTP which is sent to your phone number",
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: greyTextColor),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              await provider.forgotPasswordGetOtp(
                                                  phn: _phnController.text);
                                            },
                                            child: const Text("Resend")),
                                        _buildCreateNewPassword(
                                            context: context, theme: theme),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          ReusableButton(
                            action: () async {
                              if (provider.otpSuccess == true) {
                                print(_otpController.text);
                                final result = await provider.changePassword(
                                    password: _passwordCont.text,
                                    phone: _phnController.text,
                                    otp: _otpController.text);
                        
                                if (result == "success") {
                                  print("success");
                                  Navigator.pop(context);
                                  CommonSnackbar.show(
                                    context,
                                        message: "Password changed successfully!"
                                  );
                                } else {
                                  CommonSnackbar.show(
                                    context,
                                        message: "Something went wrong"
                                  );
                                }
                              } else {
                                if (_forgotPwFormKey.currentState!.validate()) {
                                  final result = await provider.forgotPasswordGetOtp(
                                      phn: _phnController.text);
                        
                                  if (result == "success") {
                                    CommonSnackbar.show(context,
                                        message: "OTP sent to your mobile number");
                                  } else {
                                    CommonSnackbar.show(context,
                                        message: result.toString());
                                  }
                                }
                              }
                        
                              //   if (_forgotPwFormKey.currentState!.validate()) {
                              //     context.read<AuthBloc>().add(
                              //         ForgotPasswordEvent(
                              //             phone: _phnController.text.trim()));
                              //   }
                        
                              //   setState(() {
                              //     _isOtp = false;
                              //   });
                            },
                            text: provider.otpSuccess ? "Confirm" : "Send OTP",
                            height: 40.h,
                            textColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
    }

  Widget _buildCreateNewPassword(
      {required BuildContext context, required ThemeData theme}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _createPwFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ReusableTextfield(
                controller: _passwordCont,
                onChanged: _validatePassword,
                labelText: "Password",
                validation: (_) {
                  if (_passwordCont.text.trim().isEmpty) {
                    return "This field is required";
                  } else if (_passwordCont.text.length < 8) {
                    return "Password must contain 8 letters";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ReusableTextfield(
                controller: _confirmPwCont,
                labelText: "Re-enter password",
                validation: (_) {
                  if (_confirmPwCont.text.trim().isEmpty) {
                    return "This field is required";
                  } else if (_passwordCont.text != _confirmPwCont.text) {
                    return "Password doesn't match";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ValidationCheckbox(
                title: 'At least 8 characters',
                isValid: hasEightChars,
              ),
              ValidationCheckbox(
                title: 'Contains uppercase letter',
                isValid: hasUppercase,
              ),
              ValidationCheckbox(
                title: 'Contains lowercase letter',
                isValid: hasSmallLetter,
              ),
              ValidationCheckbox(
                title: 'Contains special character',
                isValid: hasSpecialChar,
              ),
              ValidationCheckbox(
                title: 'Contains number',
                isValid: hasNumber,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: PinCodeTextField(
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
        // validator: (_) {
        //   if (_otpController.text.trim().isEmpty) {
        //     return "Please enter OTP";
        //   }
        //   return null;
        // },
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
          // final result = await Provider.of<LoginProvider>(context, listen: false)
          // .forgotPassword(phn: phn)
          // context.read<AuthBloc>().add(MobileOtpVerifyEvent(
          //     phone: _phnController.text.trim(), otp: _otpController.text));
          // setState(() {
          //   _createPw = true;
          // });
        },
      ),
    );
  }
}

class ValidationCheckbox extends StatelessWidget {
  final String title;
  final bool isValid;

  const ValidationCheckbox({
    required this.title,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_box : Icons.check_box_outline_blank,
            color: isValid ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
