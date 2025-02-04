import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/plans/widgets/plan_card_widget.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';

class PlansScreen extends StatefulWidget {
  final bool? fromSettings;
  const PlansScreen({Key? key, this.fromSettings}) : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _currentIndex = 0;
  late AppThemeDataBloc _themeBloc;

  final Map<String, List<bool>> _planFeatures = {
    "Standard": [true, true, true, true, true, false, false, false],
    "Classic": [true, true, true, true, true, true, false, false],
    "Premium": [true, true, true, true, true, true, true, true],
  };

  final Map<String, List<bool>> _resdexFeatures = {
    "Resdex Lite": [true, true, true, true, true, false, false, false],
    "Resdex Premium": [true, true, true, true, true, true, true, true],
  };

  final Map<String, String> _prices = {
    "Standard": "400",
    "Classic": "800",
    "Premium": "1650",
    "Resdex Lite": "4000",
    "Resdex Premium": "10500",
  };

  List<Map<String, dynamic>> _generatePlan(String name, List<String> features, Map<String, List<bool>> featureMap) {
    return List.generate(features.length, (i) => {
      "title": features[i],
      "is_applicable": featureMap[name]![i],
      "plan_name": name,
      "rupees": _prices[name]!
    });
  }

  late List<List<Map<String, dynamic>>> jobPostingPlans;
  late List<List<Map<String, dynamic>>> resdexPlans;

  @override
  void initState() {
    super.initState();
    _themeBloc = AppThemeDataBloc();

    List<String> jobPostingFeatures = [
      "Upto 250 character job description",
      "1 job location",
      "200 applies",
      "Applies expiry 30 days",
      "1 job location",
      "Jobseeker contact details are visible",
      "Boost on Job Search Page",
      "Job Branding"
    ];

    List<String> resdexFeatures = [
      "100 CV views per requirement",
      "Up to 500 search results",
      "Candidates active in last 6 months",
      "10+ advanced filters",
      "Single user access",
      "Download CVs in bulk",
      "Keyword search",
      "Create an email template to invite a candidate"
    ];

    jobPostingPlans = ["Standard", "Classic", "Premium"]
        .map((name) => _generatePlan(name, jobPostingFeatures, _planFeatures))
        .toList();
    resdexPlans = ["Resdex Lite", "Resdex Premium"]
        .map((name) => _generatePlan(name, resdexFeatures, _resdexFeatures))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: widget.fromSettings == true
                      ? const Expanded(
                          child: CommonAppbarWidget(
                              isBackArrow: true, title: "Plans Screen"))
                      : Text("Planning prices",
                          style: theme.textTheme.headlineMedium),
                ),
                Text("Hire skilled candidates for your business",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: greyTextColor)),
                const SizedBox(height: 20),
                TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [Tab(text: "Job Posting"), Tab(text: "Resdex")],
                  labelColor: _themeBloc.state.isDarkMode
                      ? darkTextColor
                      : lightTextColor,
                  labelStyle: theme.textTheme.bodyLarge,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: buttonColor,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildPlanView(jobPostingPlans),
                      _buildPlanView(resdexPlans)
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

  Widget _buildPlanView(List<List<Map<String, dynamic>>> plans) {
    return Center(
      child: CarouselSlider(
        items: plans.map((plan) => _buildPlanCard(plan, plans)).toList(),
        options: CarouselOptions(
          aspectRatio: 2 / 3,
          enlargeCenterPage: true,
          autoPlay: false,
          onPageChanged: (index, reason) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }

  Widget _buildPlanCard(List<Map<String, dynamic>> plan,
      List<List<Map<String, dynamic>>> planList) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _currentIndex == planList.indexOf(plan)
            ? secondaryColor
            : buttonColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: PlanCardWidget(lists: plan),
    );
  }
}
