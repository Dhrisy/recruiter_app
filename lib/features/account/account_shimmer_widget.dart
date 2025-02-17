import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class AccountShimmerWidget extends StatelessWidget {
  const AccountShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const SizedBox(
              height: 40,
            ),
            Column(
             
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 200.w,
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                const SizedBox(height: 15),
                _biuldAboutWidget(),
                const SizedBox(height: 15),
                ShimmerWidget(
                  width: 200.w,
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                const SizedBox(height: 15),
                _biuldAboutWidget(),
                const SizedBox(height: 15),
                ShimmerWidget(
                  width: 200.w,
                  height: 20.h,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                const SizedBox(height: 15),
                _biuldAboutWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _biuldAboutWidget() {
    return ShimmerWidget(
      width: double.infinity,
      height: 90.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    );
  }
}
