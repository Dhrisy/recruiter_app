import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/account/account_shimmer_widget.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:sliver_snap/widgets/sliver_snap.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccountProvider>(context, listen: false).fetchAccountData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Material(
      child: Scaffold(
        // backgroundColor: scaffoldbacgroundColor,
        body: Consumer<AccountProvider>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              provider.isLoading
                  ? AccountShimmerWidget()
                  : provider.accountData == null
                      ? CommonErrorWidget()
                      : Expanded(
                          child: _buildAccountWidget(
                              theme: theme, provider: provider)),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _launchWebsiteUrl(String website) async {
    try {
      // Ensure the URL starts with "https://"
      if (!website.startsWith('http://') && !website.startsWith('https://')) {
        website = 'https://$website';
      }

      final Uri url = Uri.parse(website);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Show user-friendly error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open URL: $website')),
      );
    }
  }

  Widget _buildAccountWidget(
      {required ThemeData theme, required AccountProvider provider}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SliverSnap(
            onCollapseStateChanged:
                (isCollapsed, scrollingOffset, maxExtent) {},
            collapsedBackgroundColor: secondaryColor,
            expandedBackgroundColor: Colors.transparent,
            backdropWidget: Container(
              width: double.infinity,
              child: SvgPicture.asset(
                "assets/svgs/group_circle.svg",
                fit: BoxFit.cover,
              ),
            ),
            // bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(20.h),
            //     child: Row(
            //       children: [
            //         Text(
            //           CustomFunctions.toSentenceCase(
            //             "name",
            //           ),
            //           style: theme.textTheme.headlineLarge!
            //               .copyWith(color: Colors.black),
            //         )
            //       ],
            //     )),
            collapsedBarHeight: 50.h,
            expandedContentHeight: 130.h,
            expandedContent: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Account",
                          style: theme.textTheme.headlineMedium,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                AnimatedNavigation()
                                    .slideAnimation(Questionaire1(
                                      index: 1,
                                      accountData: provider.accountData,
                                    )));
                          },
                          child: SizedBox(
                            child: Icon(Icons.edit),
                          ),
                        ),
                        SizedBox(
                          child: Icon(Icons.settings),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 15,
                      children: [
                        CircleAvatar(
                          radius: 45.r,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            "assets/images/default_company_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              CustomFunctions.toSentenceCase("name"),
                              style: theme.textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            // Text(CustomFunctions.toSentenceCase(provider.accountData!.name.toString())),
                            Row(
                              children: [
                                Text("Website: ",
                                    style: theme.textTheme.bodyMedium),
                                InkWell(
                                    onTap: () {
                                      // _launchURL("www.youtube.com");
                                      _launchWebsiteUrl("www.youtube.com");
                                    },
                                    child: Text(
                                      provider.accountData!.website.toString(),
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(color: Colors.blue),
                                    )),
                              ],
                            ),
                            Text(
                                "Funtional area: ${provider.accountData!.functionalArea}")
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            collapsedContent: Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  Text(
                    CustomFunctions.toSentenceCase("name"),
                    style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAboutCompanyWidget(
                        theme: theme,
                        description: provider.accountData!.about ?? "N/A"),
                    _buildLocationDetailsWidget(
                        theme: theme, provider: provider),
                    _buildAdditionalInfoWidget(theme: theme, provider: provider)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCompanyWidget(
      {required ThemeData theme, required String description}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                blurRadius: 4.r,
                color: const Color.fromARGB(255, 202, 199, 199),
                offset: const Offset(1, 1))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleWidget(theme: theme, text: "About company"),
            _buildDescriptionWidget(theme: theme, description: description)
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsWidget(
      {required ThemeData theme, required AccountProvider provider}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                blurRadius: 4.r,
                color: const Color.fromARGB(255, 202, 199, 199),
                offset: const Offset(1, 1))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleWidget(theme: theme, text: "Location Details"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Address",
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            provider.accountData!.address != null
                ? Row(
                    children: List.generate(
                        provider.accountData!.address!.length, (index) {
                      final address = provider.accountData!.address![index];
                      return Text(
                        "${CustomFunctions.toSentenceCase(address)}, ",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: greyTextColor),
                      );
                    }),
                  )
                : Text(
                    "N/A",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: greyTextColor),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemWidget(
                    theme: theme,
                    title: "City",
                    subTitle: provider.accountData!.city ?? "N/A"),
                _buildItemWidget(
                    theme: theme,
                    title: "Country",
                    subTitle: provider.accountData!.country ?? "N/A")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Postal code",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  CustomFunctions.toSentenceCase(
                      provider.accountData!.postalCode ?? "N/A"),
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: greyTextColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoWidget(
      {required ThemeData theme, required AccountProvider provider}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                blurRadius: 4.r,
                color: const Color.fromARGB(255, 202, 199, 199),
                offset: const Offset(1, 1))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleWidget(theme: theme, text: "Additional Information"),
            _buildItemWidget(
                theme: theme,
                title: "Contact Person",
                subTitle: provider.accountData!.contactName ?? "N/A"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemWidget(
                    theme: theme,
                    title: "Contact Number",
                    subTitle: provider.accountData!.contactLandNumber ?? "N/A"),
                _buildItemWidget(
                    theme: theme,
                    title: "Landline Number",
                    subTitle: provider.accountData!.contactLandNumber ?? "N/A")
              ],
            ),
            _buildItemWidget(
                theme: theme,
                title: "Designation",
                subTitle: provider.accountData!.designation ?? "N/A")
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(
      {required ThemeData theme,
      required String title,
      required String subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          CustomFunctions.toSentenceCase(subTitle),
          style: theme.textTheme.bodyMedium!.copyWith(color: greyTextColor),
        )
      ],
    );
  }

  Widget _buildTitleWidget({required ThemeData theme, required String text}) {
    return Text(
      text,
      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescriptionWidget(
      {required ThemeData theme, required String description}) {
    return Text(
      description,
      style: theme.textTheme.bodyMedium!
          .copyWith(fontSize: 14.sp, color: greyTextColor),
    );
  }
}
