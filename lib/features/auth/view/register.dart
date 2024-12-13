import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/auth/view/otp_screen.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
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
            onTap: () {
              print("ssssssssssss");
            },
            child: SvgPicture.asset("assets/svgs/google_img.svg")),
        const SizedBox(width: 20),
        SvgPicture.asset("assets/svgs/facebook_img.svg")
      ],
    );
  }

  Widget _buildRegisterModule(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
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
                      validation: (_) {},
                      labelText: "Full name",
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextfield(
                      controller: _emailCont,
                      validation: (_) {},
                      labelText: "Email",
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextfield(
                      controller: _phnCont,
                      validation: (_) {},
                      labelText: "Contact number",
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextfield(
                      controller: _pwCont,
                      validation: (_) {},
                      labelText: "Password",
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableTextfield(
                      controller: _confirmPwCont,
                      validation: (_) {},
                      labelText: "Confirm password",
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableButton(
                      action: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 550),
                            curve: Curves.easeInOut);
                      },
                      text: "Next",
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
        ],
      ),
    );
  }
}
