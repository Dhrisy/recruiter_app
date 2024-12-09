import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2, // Number of tabs
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Planning prices",
                      style: AppTheme.headingText(secondaryColor),
                    ),
                  ],
                ),
                Text(
                  "Hire skilled candidates for your business",
                  style: AppTheme.smallText(secondaryColor),
                ),
                const SizedBox(height: 20),
                TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      text: "Job Posting",
                    ),
                    Tab(
                      text: "Resdex",
                    ),
                  ],
                  labelColor: Colors.black,
                  labelStyle: AppTheme.bodyText(Colors.black)
                      .copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: buttonColor,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildJobPostingPlan(),
                      Center(
                        child: Container(
                          height: 100,
                          width: 200,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobPostingPlan() {
    return Center(
      child: CarouselSlider(
        items: List.generate(
          5,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                color: _currentIndex == index ? secondaryColor : buttonColor,
                borderRadius: BorderRadius.circular(20.r)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Standard",
                  style: AppTheme.headingText(Colors.white),),
                  
                  Text('\$ 400',
                  style: AppTheme.headingText(Colors.white),)
                ],
              ),
            ),
          ),
        ),
        options: CarouselOptions(
          aspectRatio: 2 / 3,

          //  height: 245,
          // viewportFraction: 0.57,
          enlargeCenterPage: true,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
