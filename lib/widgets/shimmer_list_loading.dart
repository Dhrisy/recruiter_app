import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/widgets/shimmer_widget.dart';

class ShimmerListLoading extends StatelessWidget {
  const ShimmerListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ShimmerWidget(
              width: double.infinity, 
              height: 90.h,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: 3),
    );
  }
}
