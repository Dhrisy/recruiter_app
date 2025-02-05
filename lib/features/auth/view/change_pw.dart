import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class ChangePw extends StatefulWidget {
  @override
  _ChangePwState createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonAppbarWidget(
                    title: "Change Password",
                    isBackArrow: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: _validatePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red.shade900)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red.shade900)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    onChanged: (value) {
                      if (_passwordController.text.trim().isNotEmpty &&
                          value != _passwordController.text) {
                        setState(() {
                          isMatch = false;
                        });
                      } else {
                        setState(() {
                          isMatch = true;
                        });
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: borderColor)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red.shade900)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red.shade900)),
                    ),
                  ),
                  isMatch == false
                      ? Text(
                          "Password doesn't match",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.red),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: 20),
                  Text('Password Requirements:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                  SizedBox(height: 10),
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
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child:
                  Consumer<LoginProvider>(builder: (context, provider, child) {
                return ReusableButton(
                    isLoading: provider.isLoading,
                    buttonColor: isMatch == false ||
                            _passwordController.text.trim().isEmpty ||
                            _confirmPasswordController.text.trim().isEmpty
                        ? secondaryColor.withValues(alpha: 0.6)
                        : secondaryColor,
                    textColor: Colors.white,
                    action: () async {
                      final result = await provider.editUser(
                          password: _passwordController.text);

                      if (result == "success") {
                        Navigator.pop(context);
                        CommonSnackbar.show(context,
                            message: "Password changed successfully");
                      } else {
                        CommonSnackbar.show(context,
                            message: result.toString());
                      }
                    },
                    text: "Change Password");
              }),
            ),
          )
        ],
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
