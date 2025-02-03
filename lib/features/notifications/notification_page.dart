import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/notifications/notification_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/svgs/group_circle.svg",
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CommonAppbarWidget(
                      isBackArrow: true,
                      title: "Notifications"),
                  ),
                  Expanded(
                    child:
                        // notificationProvider.isLoading
                        //     ? CommonShimmerWidgets.shimmerList(itemCount: 3)
                        //         .animate()
                        //         .fadeIn(duration: 600.ms)
                        //     :
                        notificationProvider.errorMessage != null &&
                                notificationProvider.errorMessage!.isNotEmpty
                            ? Center(
                                child: Text(
                                  notificationProvider.errorMessage!,
                                  style: AppTheme.smallText(darkTextColor) ??
                                      TextStyle(
                                          fontSize: 12, color: darkTextColor),
                                ).animate().fadeIn(duration: 600.ms),
                              )
                            : (notificationProvider.notifications.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/empty_pic.png',
                                          width: 250.0.w,
                                          height: 250.0.h,
                                        )
                                            .animate()
                                            .fadeIn(duration: 600.ms)
                                            .scale(delay: 200.ms),
                                        Text('No notifications yet!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: greyTextColor))
                                            .animate()
                                            .fadeIn(duration: 600.ms),
                                        SizedBox(height: 5.0.h),
                                        Text(
                                          'You don\'t have any notifications at this time',
                                          style: AppTheme.smallText(darkTextColor)
                                                  ?.copyWith(fontSize: 10.sp) ??
                                              TextStyle(
                                                  fontSize: 10.sp,
                                                  color: darkTextColor),
                                        ).animate().fadeIn(duration: 600.ms),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        notificationProvider.notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = notificationProvider
                                          .notifications[index];
                                      return SecurityUpdateCard(
                                        title:
                                            notification.noti.title ?? 'No Title',
                                        timestamp: notification.noti.createdOn
                                                .toString() ??
                                            'Unknown',
                                        description:
                                            notification.noti.description ??
                                                'No Description',
                                      )
                                          .animate()
                                          .fadeIn(
                                            delay: Duration(
                                                milliseconds: 100 * index),
                                            duration: 600.ms,
                                          )
                                          .slideX(
                                            begin: 0.2,
                                            end: 0,
                                            delay: Duration(
                                                milliseconds: 100 * index),
                                            duration: 600.ms,
                                          );
                                    },
                                  )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityUpdateCard extends StatelessWidget {
  final String title;
  final String timestamp;
  final String description;

  const SecurityUpdateCard({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left circular avatar with gradient
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 3,
                        backgroundColor: Colors.purple.withOpacity(0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: AppTheme.titleText(Colors.black)
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp),
                              ),
                              // SizedBox(
                              //   height: 5.h,
                              // ),
                              Text(
                                "20|Dec 2021 | 20:10 PM",
                                style: AppTheme.titleText(Colors.black)
                                    .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage("assets/new_badge_icon.png")),
                            ),
                            // child: const Text(
                            //   'NEW',
                            //   style:
                            //   TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              textAlign: TextAlign.start,
              description,
              style:
                  AppTheme.smallText(darkTextColor).copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
