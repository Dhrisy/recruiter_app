

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shape;
  final bool isCircle;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.shape = const RoundedRectangleBorder(),
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: 
      isCircle
          ? 
          CircleAvatar(
              radius: width / 2,
              backgroundColor: Colors.white,
            )
          : Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: shape,
                
              ),
            ),
    );
  }
}
