import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/plans/widgets/plan_card_widget.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> _stdLists = [
    {
      "title": "Upto 250 character job description",
      "is_applicable": true,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "200 applies",
      "is_applicable": true,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "Applies expiry 30 days",
      "is_applicable": true,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "Jobseeker contact details are visible",
      "is_applicable": false,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "Boost on Job Search Page",
      "is_applicable": false,
      "plan_name": "Standard",
      "rupees": "400"
    },
    {
      "title": "Job Branding",
      "is_applicable": false,
      "plan_name": "Standard",
      "rupees": "400"
    },
  ];
  List<Map<String, dynamic>> _classicLists = [
    {
      "title": "Upto 250 character job description",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "200 applies",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "Applies expiry 30 days",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "Jobseeker contact details are visible",
      "is_applicable": true,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "Boost on Job Search Page",
      "is_applicable": false,
      "plan_name": "Classic",
      "rupees": "800"
    },
    {
      "title": "Job Branding",
      "is_applicable": false,
      "plan_name": "Classic",
      "rupees": "800"
    },
  ];
  List<Map<String, dynamic>> _premiumLists = [
    {
      "title": "Upto 250 character job description",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "200 applies",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "Applies expiry 30 days",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "1 job location",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "Jobseeker contact details are visible",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "Boost on Job Search Page",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
    {
      "title": "Job Branding",
      "is_applicable": true,
      "plan_name": "Preminum",
      "rupees": "1650"
    },
  ];

  List<Map<String, dynamic>> _resdexLiteLists = [
    {
      "title": "100 CV views per requirement",
      "is_applicable": true,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Up to 500 search results",
      "is_applicable": true,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Candidates active in last 6 months",
      "is_applicable": true,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "10+ advanced filters",
      "is_applicable": true,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Single user access",
      "is_applicable": true,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Download CVs in bulk",
      "is_applicable": false,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Keyword search",
      "is_applicable": false,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
    {
      "title": "Create an email template to invite a candidate",
      "is_applicable": false,
      "plan_name": "Resdex Lite",
      "rupees": "4000"
    },
  ];

  List<Map<String, dynamic>> _resdexPremiumLists = [
    {
      "title": "100 CV views per requirement",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Up to 500 search results",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Candidates active in last 6 months",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "10+ advanced filters",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Single user access",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Download CVs in bulk",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Keyword search",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
    {
      "title": "Create an email template to invite a candidate",
      "is_applicable": true,
      "plan_name": "Resdex Premium",
      "rupees": "10500"
    },
  ];

  List<List<Map<String, dynamic>>> jobPostingPlans = [];
  List<List<Map<String, dynamic>>> resdexPlans = [];

   late AppThemeDataBloc _themeBloc;

  @override
  void initState() {
    super.initState();
     _themeBloc = AppThemeDataBloc();
    setState(() {
      jobPostingPlans.add(_stdLists);
      jobPostingPlans.add(_classicLists);
      jobPostingPlans.add(_premiumLists);

      resdexPlans.add(_resdexLiteLists);
      resdexPlans.add(_resdexPremiumLists);
    });

    print(jobPostingPlans.length);
  }

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
     final _themeBloc = context.read<AppThemeDataBloc>();
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2, // Number of tabs
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Planning prices",
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  "Hire skilled candidates for your business",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: greyTextColor
                  ),
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
                  labelColor: _themeBloc.state.isDarkMode  ? darkTextColor : lightTextColor,
                  labelStyle: theme.textTheme.bodyLarge,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: buttonColor,
                ),
                Expanded(
                  child: TabBarView(
                    children: [_buildJobPostingPlan(), _buildResdexPlan()],
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

  Widget _buildResdexPlan() {
    return Center(
      child: CarouselSlider(
        items: List.generate(
          resdexPlans.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _currentIndex == index ? secondaryColor : buttonColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: PlanCardWidget(
              lists: resdexPlans[index],
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
