import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/features/settings/viewmodel/settings_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/common_nodatafound_widget.dart';
import 'package:recruiter_app/widgets/job_card_widget.dart';

class ClosedJobs extends StatefulWidget {
  const ClosedJobs({Key? key}) : super(key: key);

  @override
  _ClosedJobsState createState() => _ClosedJobsState();
}

class _ClosedJobsState extends State<ClosedJobs> {


@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<SettingsProvider>(context, listen: false).fetchClosedJobs();
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.hashCode.h;
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.45,
              child: SvgPicture.asset(
                "assets/svgs/onboard_1.svg",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    CommonAppbarWidget(
                      isBackArrow: true,
                      title: "Closed Jobs"),
                    Consumer<SettingsProvider>(
                        builder: (context, provider, child) {
                      if (provider.message != '') {
                        return CommonErrorWidget();
                      } else if (provider.jobsLists != null &&
                          provider.jobsLists!.isEmpty) {
                        return CommonNodatafoundWidget();
                      } else {
                        return Column(
                          children:
                              List.generate(provider.jobsLists!.length, (index) {
                                final jobData = provider.jobsLists![index];
                            return JobCardWidget(job: jobData);
                          }),
                        );
                      }
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
