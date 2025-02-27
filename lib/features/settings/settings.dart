import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/auth/view/change_pw.dart';
import 'package:recruiter_app/features/faqs/faq.dart';
import 'package:recruiter_app/features/plans/plans_screen.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/features/settings/closed_jobs.dart';
import 'package:recruiter_app/features/settings/suggestion_screen.dart';
import 'package:recruiter_app/features/settings/viewmodel/settings_provider.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.45,
            child: SvgPicture.asset(
              "assets/svgs/onboard_1.svg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonAppbarWidget(
                    title: "Settings",
                    isBackArrow: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Customize your app experience. Manage your preferences, account settings, and more to ensure everything works just the way you like",
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyText(greyTextColor)
                          .copyWith(color: greyTextColor),
                    ),
                  ),
                  Consumer<AccountProvider>(
                      builder: (context, provider, child) {
                    return _buildSettingsItem(context, 'Edit Account', () {
                      if (provider.accountData != null) {
                        Navigator.push(
                            context,
                            AnimatedNavigation().slideAnimation(Questionaire1(
                              isEdit: true,
                              accountData: provider.accountData,
                            )));
                      } else {
                        Navigator.push(
                            context,
                            AnimatedNavigation().slideAnimation(Questionaire1(
                              isEdit: true,
                            )));
                      }
                    });
                  }),
                  _buildSettingsItem(
                    context,
                    'See Plans',
                    () => Navigator.push(
                        context,
                        AnimatedNavigation().slideAnimation(PlansScreen(
                          fromSettings: true,
                        ))),
                  ),
                  _buildSettingsItem(
                    context,
                    'Change Password',
                    () => Navigator.push(context,
                        AnimatedNavigation().slideAnimation(ChangePw())),
                  ),
                  _buildSettingsItem(
                    context,
                    'Closed Jobs',
                    () => Navigator.push(context,
                        AnimatedNavigation().slideAnimation(ClosedJobs())),
                  ),
                  _buildSettingsItem(
                    context,
                    'Suggestions',
                    () => Navigator.push(
                        context,
                        AnimatedNavigation()
                            .slideAnimation(SuggestionScreen())),
                  ),
                  _buildSettingsItem(
                    context,
                    'FAQ',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FAQScreen()),
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    'Terms and Conditions',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SimplePage(title: 'Terms and Conditions')),
                    ),
                  ),
                  _buildDeleteAccount(context, text: "Delete Account",
                      action: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CommonAlertDialog(
                              title: "Delete Account",
                              message:
                                  "Are you sure you want to delete your account?",
                              onConfirm: () async {
                                
                                Provider.of<SettingsProvider>(context,
                                        listen: false)
                                    .deleteAccount(context);
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              height: 100);
                        });
                  }, isDelete: true),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableButton(
                          width: MediaQuery.of(context).size.width * 0.4.w,
                          height: MediaQuery.of(context).size.height * 0.04.h,
                          textColor: Colors.white,
                          isLoading: isLoading,
                          action: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(const Duration(seconds: 2),
                                () async {
                              final _storage = FlutterSecureStorage();
                              await _storage.deleteAll();
                              await _storage.write(
                                  key: "user", value: "installed");

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                AnimatedNavigation()
                                    .slideAnimation(SplashScreen()),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          text: "Logout")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top ellipse
          // Positioned(
          //   top: -45,
          //   left: -20,
          //   child: Image.asset(
          //     'assets/ellipse.png',
          //     width: 75,
          //     height: 75,
          //   ),
          // ),
          // Content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: Colors
                  .transparent, // Changed to transparent to see the ellipse
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Customize your app experience. Manage your preferences, account settings, and more to ensure everything works just the way you like',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, String title, VoidCallback onTap,
      {bool isDeleteAccount = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title,
            style: AppTheme.bodyText(
                    isDeleteAccount ? Colors.redAccent : Colors.black87)
                .copyWith(
              fontSize: 16,
            )
           
            ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildDeleteAccount(BuildContext context,
      {required String text,
      required VoidCallback action,
    
      required bool isDelete}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(text,
            style:  AppTheme.bodyText(isDelete == true ? Colors.red : lightTextColor).copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: action,
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title Content'),
      ),
    );
  }
}
