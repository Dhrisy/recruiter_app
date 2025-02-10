import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/plans/viewmodel/plan_provider.dart';
import 'package:recruiter_app/features/plans/widgets/plan_card_widget.dart';
import 'package:recruiter_app/features/settings/model/subscription_model.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class PlansScreen extends StatefulWidget {
  final bool? fromSettings;
  final bool? isRegister;
  const PlansScreen({Key? key, this.fromSettings, this.isRegister})
      : super(key: key);

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int _currentIndex = 0;
  bool isLoading = true;

  final List<Map<String, dynamic>> _stdLists = [
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
  final List<Map<String, dynamic>> _classicLists = [
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
  final List<Map<String, dynamic>> _premiumLists = [
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

  final List<Map<String, dynamic>> _resdexLiteLists = [
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

  final List<Map<String, dynamic>> _resdexPremiumLists = [
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await Provider.of<PlanProvider>(context, listen: false)
          .fetchPlans()
          .then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
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
                      isLoading == true
                          ? _buildLodingShimmer()
                          : _buildPlanView(false),
                      // _buildPlanView(false), // Job Posting plans
                      isLoading == true
                          ? _buildLodingShimmer()
                          : _buildPlanView(true), // Resdex plans
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

  Widget _buildPlanView(bool isResdex) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, child) {
        if (planProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (planProvider.error != null) {
          return Center(child: Text('Error: ${planProvider.error}'));
        }

        final plans = planProvider.getPlansByType(isResdex);

        List<String> features = isResdex
            ? [
                "100 CV views per requirement",
                "Up to 500 search results",
                "Candidates active in last 6 months",
                "10+ advanced filters",
                "Single user access",
                "Download CVs in bulk",
                "Keyword search",
                "Create an email template to invite a candidate"
              ]
            : [
                "Upto 250 character job description",
                "1 job location",
                "200 applies",
                "Applies expiry 30 days",
                "1 job location",
                "Jobseeker contact details are visible",
                "Boost on Job Search Page",
                "Job Branding"
              ];

        return Center(
          child: CarouselSlider.builder(
            itemCount: plans.length,
            itemBuilder: (context, index, realIndex) {
              List<Map<String, dynamic>> planFeatures = List.generate(
                  features.length,
                  (i) => {
                        "title": features[i],
                        "is_applicable": true,
                        "plan_name": plans[index].title,
                        "rupees": plans[index].rate.toString()
                      });

              return _buildPlanCard(planFeatures, plans[index], index);
            },
            options: CarouselOptions(
              aspectRatio: 2 / 3,
              enlargeCenterPage: true,
              autoPlay: false,
              onPageChanged: (index, reason) {
                // Move the setState to a post-frame callback
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _currentIndex = index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(
      List<Map<String, dynamic>> features, PlanModel plan, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _currentIndex == index ? secondaryColor : buttonColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: PlanCardWidget(
        plan: plan,
        lists: features,
        fromSettings: widget.fromSettings,
      ),
    );
  }

  Widget _buildLodingShimmer() {
    return Center(
      child: CarouselSlider.builder(
        itemCount: 3,
        itemBuilder: (context, index, realIndex) {
          return ShimmerWidget(
            width: double.infinity,
            height: double.infinity,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r)),
          );
        },
        options: CarouselOptions(
          aspectRatio: 2 / 3,
          enlargeCenterPage: true,
          autoPlay: false,
        ),
      ),
    );
  }
}
