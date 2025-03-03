import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/home/viewmodel/home_provider.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';

class ProfileCompletionCard extends StatefulWidget {
  const ProfileCompletionCard({Key? key}) : super(key: key);

  @override
  State<ProfileCompletionCard> createState() => _ProfileCompletionCardState();
}

class _ProfileCompletionCardState extends State<ProfileCompletionCard> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchRecruiterCounts();
      Provider.of<AccountProvider>(context, listen: false).fetchAccountData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
        builder: (context, accountProvider, child) {
      return InkWell(
        onTap: () {
          if (accountProvider.accountData != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Questionaire1(
                          isEdit: true,
                          accountData: accountProvider.accountData,
                        )));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Questionaire1(isEdit: true,)));
          }
          
        },
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          return Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [secondaryColor, secondaryGradientColor])),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                 ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: accountProvider.accountData != null
                              ? accountProvider.accountData!.logo.toString()
                              : "",
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: greyTextColor,
                              color: secondaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/default_company_logo.png",
                            fit: BoxFit.cover,
                          ),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "To start connecting with top talent today!",
                          style: AppTheme.bodyText(Colors.white)
                              .copyWith(fontSize: 11.sp),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          "Complete your profile!",
                          style: AppTheme.bodyText(Colors.white)
                              .copyWith( fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 30.r,
                    animation: true,
                    fillColor: Colors.transparent,
                    percent: provider.countData != null
                        ? (provider.countData!.profileCompletionPercentage /
                            100)
                        : 0.0,
                    // animateToInitialPercent: true,
                    progressColor: buttonColor,
                    // restartAnimation: true,
                    center: Text(
                      provider.countData != null
                          ? "${provider.countData!.profileCompletionPercentage.toStringAsFixed(2)}%"
                          : "0%",
                      style: AppTheme.bodyText(Colors.white)
                          ,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15.sp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
        }),
      );
    });
  }
}
