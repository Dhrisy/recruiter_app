import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/account/account_shimmer_widget.dart';
import 'package:recruiter_app/features/faqs/faq.dart';
import 'package:recruiter_app/features/questionaires/view/questionaire1.dart';
import 'package:recruiter_app/features/settings/settings.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/profile_completion_card.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';
import 'package:sliver_snap/widgets/sliver_snap.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _appbarAnimation;
  late Animation<Offset> _containerAnimation;
  late Animation<Offset> _companyAnimation;
  late Animation<Offset> _locationAnimation;
  late Animation<Offset> _infoAnimation;

  bool isLoading = true;
  bool fetchDetails = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<AccountProvider>(context, listen: false).fetchAccountData();
      Provider.of<AccountProvider>(context, listen: false)
          .fetchUserData()
          .then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        Provider.of<AccountProvider>(context, listen: false)
            .fetchAndCombineUserData()
            .then((_) {
          if (mounted) {
            setState(() {
              fetchDetails = false;
            });
          }
        });
      });
    });

    _appbarAnimation = Tween<Offset>(
            begin: const Offset(-0.5, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _containerAnimation = Tween<Offset>(
            begin: const Offset(
              -1,
              0,
            ),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _companyAnimation = Tween<Offset>(
            begin: const Offset(
              0,
              1.5,
            ),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _locationAnimation = Tween<Offset>(
            begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _infoAnimation = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Material(
      child: Scaffold(
        // backgroundColor: scaffoldbacgroundColor,
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
            Consumer<AccountProvider>(builder: (context, provider, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // provider.userData != null
                      // ? _buildCompanyData(
                      //       area: provider.accountData != null
                      //           ? provider.accountData!.functionalArea
                      //               .toString()
                      //           : "N/A",
                      //       image: CircleAvatar(
                      //         radius: 45.r,
                      //         backgroundColor: Colors.transparent,
                      //         backgroundImage: provider.accountData != null
                      //             ? NetworkImage(
                      //                 provider.accountData!.logo.toString())
                      //             : AssetImage(
                      //                 "assets/images/default_company_logo.png"),
                      //       ),
                      //       website: provider.accountData != null
                      //           ? provider.accountData!.website.toString()
                      //           : "N/A") : Text("error "),

                      //           provider.accountData != null
                      //           ?  _buildAccountWidget(provider: provider) : Text("account data is null"),

                      isLoading == true
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                                children: [
                                  ShimmerWidget(
                                    width: 100.w,
                                    height: 100.h,
                                    isCircle: true,
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    children: [
                                      ShimmerWidget(
                                        width: 150.w,
                                        height: 20.h,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                      ),
                                      const SizedBox(height: 10),
                                      ShimmerWidget(
                                        width: 150.w,
                                        height: 20.h,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                      ),
                                      const SizedBox(height: 15),
                                      ShimmerWidget(
                                        width: 150.w,
                                        height: 20.h,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                          )
                          : _buildCompanyData(
                              area: provider.accountData != null
                                  ? provider.accountData!.functionalArea
                                      .toString()
                                  : "N/A",
                              image: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                
                                  imageUrl: provider.accountData!.logo.toString(),
                                  
                                  placeholder: (context, url) => const Center(
                                    child:
                                        CircularProgressIndicator(
                                          backgroundColor: greyTextColor,
                                          color: secondaryColor,
                                        ), // Loading indicator
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/default_company_logo.png",
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                              website: provider.accountData != null
                                  ? provider.accountData!.website.toString()
                                  : "N/A"),

                      fetchDetails == true
                          ? AccountShimmerWidget()
                          : provider.accountData != null
                              ? _buildAccountWidget(provider: provider)
                              : const Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ProfileCompletionCard(),
                                ),

                      // provider.detailsFetch == true
                      //     ? ProfileCompletionCard()
                      //     : const SizedBox.shrink(),

                      // provider.accountData != null
                      //     ? _buildAccountWidget(theme: theme, provider: provider)
                      //     : ProfileCompletionCard()

                      // Text(provider.accountFetchError),

                      // isLoading == true
                      //     ? AccountShimmerWidget()
                      //     : provider.accountData != null
                      //         ? Expanded(
                      //             child: _buildAccountWidget(
                      //                 theme: theme, provider: provider))
                      //         : ProfileCompletionCard()
                      // provider.isLoading
                      //     ? AccountShimmerWidget()
                      //     : provider.accountFetchError == ""
                      //     ? ProfileCompletionCard()
                      //     :  const SizedBox()

                      // : provider.accountData == null
                      //     ? ProfileCompletionCard()
                      //     : const SizedBox()
                      // Expanded(
                      //     child: _buildAccountWidget(
                      //         theme: theme, provider: provider)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyData(
      {required String website, required Widget image, required String area}) {
    return Consumer<AccountProvider>(builder: (context, provider, child) {
      if (provider.userData == null) {
        return Text("data");
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppbarWidget(
                  title: "Account",
                  icon: Icons.settings,
                  action: () {
                    Navigator.push(context,
                        AnimatedNavigation().fadeAnimation(SettingsScreen()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SlideTransition(
                  position: _containerAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: borderColor,
                              blurRadius: 5.r,
                              offset: const Offset(0, 2))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 15,
                        children: [
                          image,
                          // CircleAvatar(
                          //   radius: 45.r,
                          //   backgroundColor: Colors.transparent,

                          //   // :  Image.asset(
                          //   //   "assets/images/default_company_logo.png",
                          //   //   fit: BoxFit.cover,
                          //   // ),
                          //   //   child: provider.accountData!.logo != null
                          //   //   ? Image.network(provider.accountData!.logo.toString(),
                          //   //   fit: BoxFit.cover,)
                          //   // :  Image.asset(
                          //   //     "assets/images/default_company_logo.png",
                          //   //     fit: BoxFit.cover,
                          //   //   ),
                          // ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  CustomFunctions.toSentenceCase(
                                      provider.userData?.name ?? "N/A"),
                                  style: AppTheme.bodyText(lightTextColor)
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                ),
                                // Text(CustomFunctions.toSentenceCase(provider.accountData!.name.toString())),
                                Row(
                                  children: [
                                    Text("🌐 Website : ",
                                        style:
                                            AppTheme.bodyText(lightTextColor)),
                                    InkWell(
                                        onTap: () {
                                          _launchWebsiteUrl(website.toString());
                                        },
                                        child: Expanded(
                                          child: Text(
                                            website.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                AppTheme.bodyText(Colors.blue),
                                          ),
                                        )),
                                  ],
                                ),
                                Text(
                                  "💼 Funtional area: ${CustomFunctions.toSentenceCase(area)}",
                                  style: AppTheme.bodyText(lightTextColor)
                                      .copyWith(fontSize: 12.sp),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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

  Widget _buildAccountWidget({required AccountProvider provider}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //       border: Border(bottom: BorderSide(color: borderColor))),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 15),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CommonAppbarWidget(
                  //           title: "Account",
                  //           icon: Icons.settings,
                  //           action: () {
                  //             if (provider.accountData != null) {
                  //               Navigator.push(
                  //                   context,
                  //                   AnimatedNavigation()
                  //                       .fadeAnimation(SettingsScreen(
                  //                     accountData: provider.accountData!,
                  //                   )));
                  //             }
                  //           },
                  //         ),
                  //         const SizedBox(
                  //           height: 10,
                  //         ),
                  //         SlideTransition(
                  //           position: _containerAnimation,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(15),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                       color: borderColor,
                  //                       blurRadius: 5.r,
                  //                       offset: const Offset(0, 2))
                  //                 ]),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 spacing: 15,
                  //                 children: [
                  //                   CircleAvatar(
                  //                       radius: 45.r,
                  //                       backgroundColor: Colors.transparent,
                  //                       backgroundImage: provider
                  //                                   .accountData!.logo !=
                  //                               null
                  //                           ? NetworkImage(provider
                  //                               .accountData!.logo
                  //                               .toString()) as ImageProvider
                  //                           : AssetImage(
                  //                               "assets/images/default_company_logo.png")
                  //                       // :  Image.asset(
                  //                       //   "assets/images/default_company_logo.png",
                  //                       //   fit: BoxFit.cover,
                  //                       // ),
                  //                       //   child: provider.accountData!.logo != null
                  //                       //   ? Image.network(provider.accountData!.logo.toString(),
                  //                       //   fit: BoxFit.cover,)
                  //                       // :  Image.asset(
                  //                       //     "assets/images/default_company_logo.png",
                  //                       //     fit: BoxFit.cover,
                  //                       //   ),
                  //                       ),
                  //                   Expanded(
                  //                     child: Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       spacing: 5,
                  //                       children: [
                  //                         Text(
                  //                           "👤 ${CustomFunctions.toSentenceCase(provider.accountData!.name ?? "N/A")}",
                  //                           style: AppTheme.bodyText(
                  //                                   lightTextColor)
                  //                               .copyWith(
                  //                                   fontWeight:
                  //                                       FontWeight.bold),
                  //                         ),
                  //                         // Text(CustomFunctions.toSentenceCase(provider.accountData!.name.toString())),
                  //                         Row(
                  //                           children: [
                  //                             Text("🌐 Website : ",
                  //                                 style: AppTheme.bodyText(
                  //                                     lightTextColor)),
                  //                             InkWell(
                  //                                 onTap: () {
                  //                                   // _launchURL("www.youtube.com");
                  //                                   _launchWebsiteUrl(
                  //                                       "www.youtube.com");
                  //                                 },
                  //                                 child: Text(
                  //                                   provider
                  //                                       .accountData!.website
                  //                                       .toString(),
                  //                                   style: AppTheme.bodyText(
                  //                                       Colors.blue),
                  //                                 )),
                  //                           ],
                  //                         ),
                  //                         Text(
                  //                             "💼 Funtional area: ${provider.accountData!.functionalArea}")
                  //                       ],
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  SlideTransition(
                    position: _companyAnimation,
                    child: _buildAboutCompanyWidget(
                        description: provider.accountData!.about ?? "N/A"),
                  ),
                  SlideTransition(
                    position: _locationAnimation,
                    child: _buildLocationDetailsWidget(provider: provider),
                  ),
                  SlideTransition(
                      position: _infoAnimation,
                      child: _buildAdditionalInfoWidget(provider: provider)),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCompanyWidget({required String description}) {
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
            _buildTitleWidget(text: "About company"),
            _buildDescriptionWidget(description: description)
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDetailsWidget({required AccountProvider provider}) {
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
            _buildTitleWidget(text: "Location Details", isEdit: true, index: 1),
            const SizedBox(
              height: 10,
            ),
            Text(
              "📍 Address",
              style: AppTheme.bodyText(lightTextColor).copyWith(
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
                        style: AppTheme.bodyText(lightTextColor)
                            .copyWith(color: greyTextColor),
                      );
                    }),
                  )
                : Text(
                    "N/A",
                    style: AppTheme.bodyText(lightTextColor)
                        .copyWith(color: greyTextColor),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemWidget(
                    title: "City",
                    subTitle: provider.accountData!.city ?? "N/A"),
                _buildItemWidget(
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
                  style: AppTheme.bodyText(lightTextColor).copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  CustomFunctions.toSentenceCase(
                      provider.accountData!.postalCode ?? "N/A"),
                  style: AppTheme.bodyText(lightTextColor)
                      .copyWith(color: greyTextColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoWidget({required AccountProvider provider}) {
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
            _buildTitleWidget(
                text: "Additional Information", index: 2, isEdit: true),
            _buildItemWidget(
                title: "Contact Person",
                subTitle: provider.accountData!.contactName ?? "N/A"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItemWidget(
                    title: "Contact Number",
                    subTitle: provider.accountData!.contactLandNumber ?? "N/A"),
                _buildItemWidget(
                    title: "Landline Number",
                    subTitle: provider.accountData!.contactLandNumber ?? "N/A")
              ],
            ),
            _buildItemWidget(
                title: "Designation",
                subTitle: provider.accountData!.designation ?? "N/A")
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget({required String title, required String subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyText(lightTextColor).copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          CustomFunctions.toSentenceCase(subTitle),
          style:
              AppTheme.bodyText(lightTextColor).copyWith(color: greyTextColor),
        )
      ],
    );
  }

  Widget _buildTitleWidget({
    required String text,
    int? index,
    bool? isEdit,
  }) {
    return Consumer<AccountProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppTheme.mediumTitleText(lightTextColor)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          isEdit == true
              ? InkWell(
                  onTap: () {
                    if (provider.accountData != null) {
                      Navigator.push(
                          context,
                          AnimatedNavigation().fadeAnimation(Questionaire1(
                            accountData: provider.accountData,
                            isEdit: true,
                            index: index ?? 0,
                          )));
                    }
                  },
                  child: Icon(Icons.edit))
              : const SizedBox.shrink()
        ],
      );
    });
  }

  Widget _buildDescriptionWidget({required String description}) {
    return Text(
      description,
      style: AppTheme.bodyText(lightTextColor)
          .copyWith(fontSize: 14.sp, color: greyTextColor),
    );
  }
}
