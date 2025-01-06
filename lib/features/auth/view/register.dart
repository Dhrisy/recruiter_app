import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/bloc/auth_event.dart';
import 'package:recruiter_app/features/auth/bloc/auth_state.dart';
import 'package:recruiter_app/features/auth/view/login_screen.dart';
import 'package:recruiter_app/features/auth/view/otp_screen.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/loading_widget.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _phnCont = TextEditingController();
  final TextEditingController _pwCont = TextEditingController();
  final TextEditingController _confirmPwCont = TextEditingController();
  late PageController _pageController; // Changed to late initialization

  bool _whatsapp_updations = true;
  final _registerFormKey = GlobalKey<FormState>();
  bool isEqual = true;
  bool pwError = false;

  @override
  void initState() {
    super.initState();
    // Initialize PageController in initState
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // Dispose of the PageController to prevent memory leaks
    _pageController.dispose();
    super.dispose();
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
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildRegisterModule(context, theme),
                      OtpScreen(
                        phone: _phnCont.text,
                        controller: _pageController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSocialLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {},
            child: SvgPicture.asset("assets/svgs/google_img.svg")),
        const SizedBox(width: 20),
        SvgPicture.asset("assets/svgs/facebook_img.svg")
      ],
    );
  }

  Widget _buildRegisterModule(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthSuccess) {
        _pageController.nextPage(duration: Duration(
                            milliseconds: 300
                          ), curve: Curves.easeInOut);
        // Navigator.pushAndRemoveUntil(context, 
        // AnimatedNavigation().slideAnimation(Questionaire1()), (Route<dynamic> route) => false);
        // CommonSnackbar.show(context, message: "Successfully logged in");
      } else if (state is AuthExists) {
        CommonSnackbar.show(context, message: "User already exists");
      } else if (state is AuthFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    }, builder: (context, state) {
      return Column(
        children: [
          Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Register your company",
                        style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 23.sp),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ReusableTextfield(
                        controller: _nameCont,
                        validation: (_) {
                          if (_nameCont.text.trim().isEmpty) {
                            return "This field is required";
                          } else if (_nameCont.text.length < 3) {
                            return "Name must contain atleast 3 letters";
                          }
                          return null;
                        },
                        labelText: "Company name",
                        // isRequired: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReusableTextfield(
                        controller: _emailCont,
                        validation: (_) {
                          if (_emailCont.text.trim().isEmpty) {
                            return "This field is required";
                          } else if (!CustomFunctions()
                              .isValidEmail(_emailCont.text)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        labelText: "Email",
                        // isRequired: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReusableTextfield(
                        controller: _phnCont,
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
                        height: 20,
                      ),
                      ReusableTextfield(
                        controller: _pwCont,
                        validation: (_) {
                          final password = _pwCont.text.trim();
                          final regex = RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                          if (password.isEmpty) {
                            return "This field is required";
                          } else if (!regex.hasMatch(password)) {
                            setState(() {
                              pwError = true;
                            });
                            return "";
                          } else if (password.length < 10) {
                            return "Password must contain at least 10 characters";
                          }

                          setState(() {
                            pwError = false;
                          });
                          return null;
                        },
                        labelText: "Password",
                        // isRequired: true,
                      ),
                      Text(
                        "Password must contain alphabets, numerics, and special characters",
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: pwError == true ? Colors.red.shade900 : greyTextColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReusableTextfield(
                        controller: _confirmPwCont,
                        validation: (_) {
                          if(_confirmPwCont.text.trim().isEmpty){
                            return "This field is required";
                          }

                          return null;
                        },
                        labelText: "Confirm password",
                        isRequired: true,
                        onChanged: (value) {
                          if (_pwCont.text != _confirmPwCont.text) {
                            setState(() {
                              isEqual = false;
                            });
                          } else {
                            setState(() {
                              isEqual = true;
                            });
                          }
                        },
                      ),
                       const SizedBox(
                        height: 5,
                      ),
                      isEqual == false
                          ? Row(
                            children: [
                              Text(
                                  "Password doesn't match",
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: Colors.red.shade900),
                                ),
                            ],
                          )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: _whatsapp_updations,
                              onChanged: (value) {
                                setState(() {
                                  _whatsapp_updations = value ?? false;
                                });
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                                  "Send me important updates & promotions via email, SMS and Whatsapp"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReusableButton(
                        isLoading: state is AuthLoading,
                        action: () {
                          // _pageController.nextPage(
                          //     duration: Duration(milliseconds: 550),
                          //     curve: Curves.easeInOut);

                          if (_registerFormKey.currentState!.validate() && isEqual == true) {
                            context.read<AuthBloc>().add(RegisterEvent(
                                companyName: _nameCont.text,
                                contactNumber: _phnCont.text,
                                email: _emailCont.text,
                                password: _pwCont.text,
                                role: "recruiter",
                                whatsappUpdations: _whatsapp_updations));



                          }

                          

                          FocusScope.of(context).unfocus();
                        },
                        text: "Send OTP",
                        textSize: 15.sp,
                        width: MediaQuery.of(context).size.width * 0.5.w,
                        height: 40.h,
                        textColor: Colors.white,
                        buttonColor: buttonColor,
                        radius: 30.r,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("or"),
                      const SizedBox(
                        height: 25,
                      ),
                      Text("Continue with"),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildSocialLogin(context)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? "),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        AnimatedNavigation().slideAnimation(LoginScreen()));
                  },
                  child: Text(
                    "Login",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: buttonColor),
                  ))
            ],
          )
        ],
      );
    }));
  }


Widget _buildOtpScreen({required String phn}){
  return Column(
    children: [
      Text("aaaaaaaaaaa")
    ],
  );
}

}
