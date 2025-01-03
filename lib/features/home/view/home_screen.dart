import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/home/view/banner_widget.dart';
import 'package:recruiter_app/features/home/view/job_credit_meter.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/widgets/profile_completion_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    _buildAppBarWidget(themeBloc: _themeBloc, theme: theme),
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
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 10,
                        children: [
                          _countContainer(
                            theme: theme,
                            color: secondaryColor,
                            count: "29",
                            title: "New",
                            subtitle: "Application",
                          ),
                          _countContainer(
                            theme: theme,
                            color: buttonColor,
                            count: "29",
                            title: "New",
                            subtitle: "Application",
                          ),
                          _countContainer(
                            theme: theme,
                            color: secondaryColor,
                            count: "29",
                            title: "New",
                            subtitle: "Application",
                          ),
                          _countContainer(
                            theme: theme,
                            color: buttonColor,
                            count: "29",
                            title: "New",
                            subtitle: "Application",
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    JobCreditMeter(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _countContainer({
    required ThemeData theme,
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
          count: count, title: title, subtitle: subtitle, theme: theme),
    );
  }

  Widget _buildCountColumn({
    required String count,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall!
                .copyWith(fontSize: 10.sp, color: Colors.white),
          ),
          Expanded(
              child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall!
                .copyWith(fontSize: 10.sp, color: Colors.white),
          ))
        ],
      ),
    );
  }

  Widget _buildAppBarWidget(
      {required AppThemeDataBloc themeBloc, required ThemeData theme}) {
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
                    radius: 30.r,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ",
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Good morning...!",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        final _storage =
                            FlutterSecureStorage(); // Remove 'await' from the constructor
                        await _storage.deleteAll();
                        await _storage.write(key: "user", value: "installed");

                        Navigator.pushAndRemoveUntil(
                          context,
                          AnimatedNavigation().slideAnimation(SplashScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      )),
                  Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                      child: SvgPicture.asset(
                    "assets/svgs/notification_icon.svg",
                  ))
                ],
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: themeBloc.state.isDarkMode
                  ? darkContainerColor
                  : lightContainerColor,
              borderRadius: BorderRadius.circular(15.r),
              // border: Border.all(color: secondaryColor),
            ),
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
          )
        ],
      ),
    );
  }

  Widget _buildCarousalBanner() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          items: [
            BannerWidget(),
            BannerWidget(),
            BannerWidget(),
          ],
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index; // Update the activeIndex
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
        ),
        SizedBox(height: 10.h),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: 3,
          effect: WormEffect(
            activeDotColor: buttonColor,
            dotColor: const Color.fromARGB(255, 140, 127, 178),
            dotHeight: 6.h,
            dotWidth: 15.w,
          ),
          onDotClicked: (index) {
            _carouselController.animateToPage(index); // Jump to selected dot
          },
        ),
      ],
    );
  }
}
