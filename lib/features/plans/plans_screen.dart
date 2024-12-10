import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/plans/widgets/plan_card_widget.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> _stdLists = [
    {"title": "Upto 250 character job description", "is_applicable": true, "plan_name": "Standard"},
    {"title": "1 job location", "is_applicable": true, "plan_name": "Standard"},
    {"title": "200 applies", "is_applicable": true, "plan_name": "Standard"},
    {"title": "Applies expiry 30 days", "is_applicable": true, "plan_name": "Standard"},
    {"title": "1 job location", "is_applicable": true, "plan_name": "Standard"},
    {"title": "Jobseeker contact details are visible", "is_applicable": false, "plan_name": "Standard"},
    {"title": "Boost on Job Search Page", "is_applicable": false, "plan_name": "Standard"},
    {"title": "Job Branding", "is_applicable": false, "plan_name": "Standard"},
  ];
  List<Map<String, dynamic>> _classicLists = [
    {"title": "Upto 250 character job description", "is_applicable": true, "plan_name": "Classic"},
    {"title": "1 job location", "is_applicable": true, "plan_name": "Classic"},
    {"title": "200 applies", "is_applicable": true, "plan_name": "Classic"},
    {"title": "Applies expiry 30 days", "is_applicable": true, "plan_name": "Classic"},
    {"title": "1 job location", "is_applicable": true, "plan_name": "Classic"},
    {"title": "Jobseeker contact details are visible", "is_applicable": true, "plan_name": "Classic"},
    {"title": "Boost on Job Search Page", "is_applicable": false, "plan_name": "Classic"},
    {"title": "Job Branding", "is_applicable": false, "plan_name": "Classic"},
  ];

  List<List<Map<String, dynamic>>> jobPostingPlans = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      jobPostingPlans.add(_stdLists);
      jobPostingPlans.add(_classicLists);
    });

    print(jobPostingPlans.length);
  }

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
          jobPostingPlans.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _currentIndex == index ? secondaryColor : buttonColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: PlanCardWidget(
              lists: jobPostingPlans[index],
            ),
          ),
        ),
        options: CarouselOptions(
          aspectRatio: 2 / 3,
          enlargeCenterPage: true,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
