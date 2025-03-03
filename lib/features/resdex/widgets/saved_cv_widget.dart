import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/resdex/model/resume_model.dart';
import 'package:recruiter_app/features/resdex/provider/resume_provider.dart';
import 'package:recruiter_app/features/resdex/widgets/pdf_view_screen.dart';
import 'package:recruiter_app/features/seeker_details/seeker_details.dart';
import 'package:recruiter_app/widgets/common_error_widget.dart';
import 'package:recruiter_app/widgets/shimmer_list_loading.dart';
import 'package:path/path.dart' as p;

class SavedCvWidget extends StatefulWidget {
  const SavedCvWidget({Key? key}) : super(key: key);

  @override
  _SavedCvWidgetState createState() => _SavedCvWidgetState();
}

class _SavedCvWidgetState extends State<SavedCvWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResumeProvider>(context, listen: false)
          .fetchREsumes()
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
    return Consumer<ResumeProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          if (isLoading) ShimmerListLoading(),
          if (provider.downloadResumes == null) CommonErrorWidget(),
          if (provider.downloadResumes != null)
            Column(
              children:
                  List.generate(provider.downloadResumes!.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildCvCard(
                      resumeData: provider.downloadResumes![index]),
                );
              }),
            )
        ],
      );
    });
  }

  Widget _buildCvCard({required ResumeModel resumeData}) {
    String fileName = resumeData.seekerData != null
        ? p.basename(resumeData.seekerData!.personal.cv.toString())
        : "N/A";
    return AnimatedContainer(
      duration: 500.ms,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/cv_folder.webp",
                height: 50,
                width: 60,
              ),
              Expanded(
                child: Text(CustomFunctions.toSentenceCase(fileName),
                overflow: TextOverflow.ellipsis,
                    style: AppTheme.bodyText(lightTextColor)),
              ),
            ],
          ),
          childrenPadding: EdgeInsets.only(bottom: 10),
          children: [
            const Divider(),
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          AnimatedNavigation().fadeAnimation(PdfViewerScreen(
                            cv: "https://job.emergiogames.com${resumeData.seekerData!.personal.cv}",
                          )));
                    },
                    label: Text("View CV",
                        style: AppTheme.bodyText(lightTextColor))),
//                 OutlinedButton.icon(
//                     onPressed: () {
// // Navigator.push(context, AnimatedNavigation().fadeAnimation(SeekerDetails(seekerData: SeekerM)))
//                     },
//                     icon: Icon(Icons.visibility),
//                     label: Text("View seeker details",
//                         style: AppTheme.bodyText(lightTextColor))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
