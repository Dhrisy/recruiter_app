import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/home/view/banner_widget.dart';
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
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    _buildCarousalBanner(),
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileCompletionCard()
                  ],
                ),
              )
            ],
          ),
        ),
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
                    children: [
                      Text("asdfghj"),
                      Text("asdfghj"),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
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
