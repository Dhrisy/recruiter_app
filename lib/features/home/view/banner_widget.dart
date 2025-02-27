import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/home/model/banner_model.dart';

class BannerWidget extends StatelessWidget {
  final BannerModel banner;
  const BannerWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
              image: banner.image != null
                  ? NetworkImage(banner.image!)
                  : AssetImage("assets/images/banner_image.png"),
              fit: BoxFit.cover)),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "Get 1k+ featured Jobs",
      //             style:
      //                 theme.textTheme.bodySmall!.copyWith(color: Colors.white),
      //           ),
      //           Container(
      //             height: screenHeight * 0.025,
      //             width: screenWidth * 0.2,
      //             decoration: BoxDecoration(
      //                 color: buttonColor,
      //                 borderRadius: BorderRadius.circular(20.r)),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Expanded(
      //                   child: Text(
      //                     "Upgrade now",
      //                     textAlign: TextAlign.center,
      //                     overflow: TextOverflow.ellipsis,
      //                     style: theme.textTheme.bodySmall!
      //                         .copyWith(color: Colors.white, fontSize: 8.sp),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           )
      //         ],
      //       )
          
          
      //     ],
      //   ),
      // ),
    );
  }
}
