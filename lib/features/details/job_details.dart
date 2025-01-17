import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobDetails extends StatelessWidget {
  final JobPostModel jobData;
  const JobDetails({Key? key, required this.jobData}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: MediaQuery.of(context).size.height * 0.08,
                maxHeight: MediaQuery.of(context).size.height * 0.15,
                child: AnimatedHeader(jobData: jobData),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rest of your content remains the same
                    _buildSection(
                      'Job Overview',
                      Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        //   _buildInfoRow(Icons.business, 'Company', jobData.title ?? 'N/A'),
                        //  _buildInfoRow(Icons.location_on, 'Location', jobData.title ?? 'N/A'),
                        //   _buildInfoRow(Icons.work, 'Experience', '${jobData.title}-${jobData.title} years'),
                        //   _buildInfoRow(Icons.attach_money, 'Salary', '${jobData.title}-${jobData.title}'),
                          _basicDetails(theme: theme),
                          proffesionalDetails(),
                          aboutCompany()

                          
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ... rest of your sections
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _basicDetails({
    String? currentndustry,
    String? role,
    String? jobRole,
    String? department,
    String? category,
    String? experience,
    String? salary,
    String? location,
    String? email,
    String? phone,
    String? availability,
    required ThemeData theme
  }) {
    return Container(
      decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: secondaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [

            _buildInfoWidget(theme: theme, title: "Industry type", subTitle: jobData.industry.toString()),


            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.work, size: 16.sp,),
                SizedBox(
                  width: 20.w,
                ),
                Text(experience ?? "No Data",
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Icon(Icons.place, size: 16.sp,),
                SizedBox(
                  width: 20.w,
                ),
                Text(location ?? "No Data",
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Icon(Icons.currency_rupee, size: 16.sp,),
                SizedBox(
                  width: 20.w,
                ),
                Text(salary ?? "No Data",
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoWidget({required ThemeData theme, required String title, required String subTitle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
                style: theme.textTheme.bodyLarge!.copyWith(

                )),
            SizedBox(
              height: 5.h,
            ),
            Text(subTitle,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 18.sp
                )),
      ],
    );

  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget aboutCompany() {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.2),
            //   spreadRadius: 2,
            //   blurRadius: 2,
            //   offset: Offset(0, 3),
            // ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( "No Data",
                style: AppTheme.smallText(
                  lightTextColor,
                ).copyWith()),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  // child: Image(image: AssetImage("assets/SuitcaseImage.png")),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text( "No Data",
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  // child: Image(image: AssetImage("assets/locationImage.png")),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text( "No Data",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.mediumTitleText(
                      lightTextColor,
                    ).copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget proffesionalDetails() {
   return Container(
    width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: buttonColor),
               ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What you\'ll do',
                      style: AppTheme.mediumTitleText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                  "N/A",
                    style: AppTheme.smallText(
                      lightTextColor,
                    ).copyWith(),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text('Requirements',
                      style: AppTheme.mediumTitleText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                      "N/A",
                      style: AppTheme.smallText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text('Roles and Responsibilities',
                      style: AppTheme.mediumTitleText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                     "N/A",
                      style: AppTheme.smallText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text('Benefits',
                      style: AppTheme.mediumTitleText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                     "N/A",
                      style: AppTheme.smallText(
                        lightTextColor,
                      ).copyWith()),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          );
  }

}

// Keep your existing AnimatedHeader and _SliverAppBarDelegate classes as they are
class AnimatedHeader extends StatelessWidget {
  final JobPostModel jobData;
  const AnimatedHeader({Key? key, required this.jobData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollPercentage = (constraints.maxHeight - MediaQuery.of(context).size.height * 0.08) / 
                               (MediaQuery.of(context).size.height * 0.15 - MediaQuery.of(context).size.height * 0.08);
        
        // Calculate sizes based on scroll position
        final logoSize = 30.r + (30.r * scrollPercentage);
        final titleFontSize = 14.sp + (6.sp * scrollPercentage);
        final subtitleFontSize = 12.sp + (2.sp * scrollPercentage);
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: borderColor,
              )
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  height: logoSize,
                  width: logoSize,
                  child: CircleAvatar(
                    radius: logoSize / 2,
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Animated Title and Subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CustomFunctions.toSentenceCase(jobData.title.toString()),
                        style: TextStyle(
                          color: lightTextColor,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.place, size: 18.sp, color: buttonColor,),
                          Text(
                            '${CustomFunctions.toSentenceCase(jobData.city.toString())}, ${CustomFunctions.toSentenceCase(jobData.country.toString())}',
                            style: TextStyle(
                              color: lightTextColor,
                              fontSize: subtitleFontSize,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}