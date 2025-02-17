import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/home/view/banner_widget.dart';
import 'package:recruiter_app/features/home/view/job_credit_meter.dart';
import 'package:recruiter_app/features/home/view/recently_added_jobs_lists.dart';
import 'package:recruiter_app/features/home/viewmodel/home_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/jobpost_provider.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/notifications/notification_page.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/services/one_signal_service.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:recruiter_app/widgets/common_alertdialogue.dart';
import 'package:recruiter_app/widgets/profile_completion_card.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final PageController _pageController = PageController();
  int activeIndex = 0;
  String _name = 'Name';
  bool isHomeLoading = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final value = await Provider.of<LoginProvider>(context, listen: false)
          .checkSubscriptions();
      if (value != null && value == false) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CommonAlertDialog(
                  title: "Expired",
                  message: "Your subscription is over",
                  onConfirm: () {},
                  onCancel: () {},
                  height: 200);
            });
      } else if (value != null && value == true) {
        if (mounted) {
          setState(() {
            isHomeLoading = false;
          });
        }
        Provider.of<HomeProvider>(context, listen: false)
            .fetchRecruiterCounts();
        OneSignalService().oneSIgnalIdSetToApi();
        Provider.of<HomeProvider>(context, listen: false)
            .fetchBanners()
            .then((_) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
        Provider.of<AccountProvider>(context, listen: false).fetchAccountData();
      } else {
        print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrorrrrrrrrrrrrr");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeBloc = context.read<AppThemeDataBloc>();
    return Material(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: (){

        // },
        // child: Icon(Icons.add),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isHomeLoading == true
                  ? _buildHomeLoading()
                  : const SizedBox.shrink(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17.h,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      decoration: BoxDecoration(),
                      child: SvgPicture.asset(
                        "assets/svgs/home_top_widget.svg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    _buildAppBarWidget(themeBloc: _themeBloc,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    _buildCarousalBanner(),
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileCompletionCard(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Analytics",
                          style: AppTheme.titleText(lightTextColor).copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Consumer<HomeProvider>(
                          builder: (context, provider, child) {
                        return Row(
                          spacing: 10,
                          children: [
                            _countContainer(
                              color: secondaryColor,
                              count: provider.countData != null
                                  ? provider.countData!.applicationCount
                                      .toString()
                                  : "0",
                              title: "New",
                              subtitle: "Application",
                            ),
                            _countContainer(
                              
                              color: buttonColor,
                              count: provider.countData != null
                                  ? provider.countData!.interviewScheduledCount
                                      .toString()
                                  : "0",
                              title: "Interview",
                              subtitle: "Scheduled",
                            ),
                            _countContainer(
                              
                              color: secondaryColor,
                              count: provider.countData != null
                                  ? provider.countData!.activeJobsCount
                                      .toString()
                                  : "0",
                              title: "Active",
                              subtitle: "Job Count",
                            ),
                            _countContainer(
                             
                              color: buttonColor,
                              count: provider.countData != null
                                  ? provider.countData!.inactiveJobsCount
                                      .toString()
                                  : "0",
                              title: "Closed",
                              subtitle: "Job",
                            )
                          ],
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobCreditMeter(),
                    const SizedBox(
                      height: 10,
                    ),
                    RecentlyAddedJobsLists(),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeLoading() {
    return Column(
      children: [],
    );
  }

  Widget _countContainer({
    
    required Color color,
    required String count,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 60.h,
      width: 80.w,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20.r)),
      child: _buildCountColumn(
          count: count, title: title, subtitle: subtitle,),
    ).animate().fadeIn(duration: 500.ms).scale();
  }

  Widget _buildCountColumn({
    required String count,
    required String title,
    required String subtitle,
    
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: AppTheme.mediumTitleText(Colors.white).copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            title,
            style: AppTheme.bodyText(Colors.white).copyWith(
              fontSize: 11.sp
            ),
          ),
          Expanded(
              child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodyText(Colors.white).copyWith(
              fontSize: 10.sp
            )
          ))
        ],
      ),
    );
  }

  Widget _buildAppBarWidget(
      {required AppThemeDataBloc themeBloc}) {
    return Consumer<AccountProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          const AssetImage("assets/images/default_logo.webp"),
                      // backgroundImage: provider.accountData != null
                      // ? NetworkImage(provider.accountData!.logo.toString())
                      // : AssetImage("assets/images/default_logo.webp"),
                    ).animate().fadeIn(duration: 500.ms).scale(),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${provider.accountData != null ? provider.accountData!.name : ""}",
                          style: AppTheme.headingText(Colors.white)
                              .copyWith(fontSize: 18.sp),
                        ).animate().fadeIn(duration: 500.ms).scale(),
                        Text(
                          "Begin your quest for discovery!",
                          style: AppTheme.bodyText(Colors.white)
                              .copyWith(fontSize: 12.sp),
                        ).animate().fadeIn(duration: 600.ms).scale(),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimatedNavigation()
                                .slideAnimation(NotificationPage()));
                      },
                      child: SizedBox(
                          child: SvgPicture.asset(
                        "assets/svgs/notification_icon.svg",
                      )).animate().fadeIn(duration: 500.ms).scale(),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    AnimatedNavigation().slideAnimation(CustomBottomNavBar(
                      index: 1,
                    )));
              },
              child: Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  color: themeBloc.state.isDarkMode
                      ? darkContainerColor
                      : lightContainerColor,
                  borderRadius: BorderRadius.circular(15.r),
                  // border: Border.all(color: secondaryColor),
                ),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: GoogleFonts.wixMadeforDisplay(),
                      filled: true,
                      fillColor: themeBloc.state.isDarkMode
                          ? darkContainerColor
                          : lightContainerColor,
                      suffixIcon: const Icon(CupertinoIcons.search),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(color: secondaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(color: secondaryColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(color: secondaryColor)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildCarousalBanner() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      if (provider.bannersLists == null) {
        return Text("null");
      }

      return Column(
        children: [
          isLoading == true
              ? _buildBannerLoading()
              : CarouselSlider(
                  carouselController: _carouselController,
                  items: List.generate(provider.bannersLists!.length, (index) {
                    final banner = provider.bannersLists![index];
                    return BannerWidget(
                      banner: banner,
                    );
                  }),
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    height: 130.h,
                    viewportFraction: 1,
                    aspectRatio: 10 / 9,
                    autoPlay: true,
                    autoPlayCurve: Curves.linearToEaseOut,
                    animateToClosest: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 200),
                  ),
                ),
          SizedBox(height: 10.h),
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: provider.bannersLists!.length,
            effect: WormEffect(
              activeDotColor: buttonColor,
              dotColor: const Color.fromARGB(255, 140, 127, 178),
              dotHeight: 6.h,
              dotWidth: 15.w,
            ),
            onDotClicked: (index) {
              _carouselController.animateToPage(index);
            },
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.5, end: 0);
    });
  }

  Widget _buildBannerLoading() {
    return CarouselSlider(
      carouselController: _carouselController,
      items: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ShimmerWidget(
            height: double.infinity,
            width: double.infinity,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r)),
          ),
        );
      }),
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            activeIndex = index;
          });
        },
        scrollDirection: Axis.horizontal,
        height: 130.h,
        viewportFraction: 1,
        aspectRatio: 10 / 9,
        autoPlay: true,
        autoPlayCurve: Curves.linearToEaseOut,
        animateToClosest: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
