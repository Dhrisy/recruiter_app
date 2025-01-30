// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SuccessfullyRegisteredScreen extends StatelessWidget {
// const SuccessfullyRegisteredScreen({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context){
//      return Material(
//        child: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/success_animation.gif"),
//           fit: BoxFit.cover)

//         ),
//         // child: Image.asset("assets/images/success_animation.gif"),
//            ),
//      );

//   }
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import '../../../../core/constants.dart';

// class SuccessfullyRegisteredScreen extends StatefulWidget {
//   const SuccessfullyRegisteredScreen({Key? key}) : super(key: key);

//   @override
//   _SuccessfullyRegisteredScreenState createState() =>
//       _SuccessfullyRegisteredScreenState();
// }

// class _SuccessfullyRegisteredScreenState extends State<SuccessfullyRegisteredScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final List<BallAnimation> _ballAnimations = [];

//   @override
//   void initState() {
//     super.initState();

//     // Create animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat(reverse: true);

//     // Generate multiple balls with random properties
//     _generateBalls(15); // Creates 15 balls
//   }

//   void _generateBalls(int count) {
//     final random = math.Random();

//     for (int i = 0; i < count; i++) {
//       // Randomize start and end positions
//       final startX = _getRandomOffset();
//       final startY = _getRandomOffset();
//       final endX = _getRandomOffset();
//       final endY = _getRandomOffset();

//       // Randomize ball sizes
//       final minSize = 20.0;
//       final maxSize = 80.0;
//       final startSize = minSize + random.nextDouble() * (maxSize - minSize);
//       final endSize = minSize + random.nextDouble() * (maxSize - minSize);

//       // Randomize color opacity
//       final opacity = 0.2 + random.nextDouble() * 0.5;

//       // Create ball animation with brand colors
//       final ballAnimation = BallAnimation(
//         startX: startX,
//         startY: startY,
//         endX: endX,
//         endY: endY,
//         startSize: startSize,
//         endSize: endSize,
//         color: _getColorVariation(buttonColor).withOpacity(opacity),
//         curve: _getRandomCurve(),
//       );

//       _ballAnimations.add(ballAnimation);
//     }
//   }

//   // Generate random offset between -1 and 1
//   double _getRandomOffset() {
//     final random = math.Random();
//     return -1 + random.nextDouble() * 2;
//   }

//   // Generate color variation based on base color
//   Color _getColorVariation(Color baseColor) {
//     final random = math.Random();
//     return Color.fromRGBO(
//         (baseColor.red + random.nextInt(60) - 25).clamp(0, 255),
//         (baseColor.green + random.nextInt(10) - 25).clamp(0, 255),
//         (baseColor.blue + random.nextInt(100) - 25).clamp(0, 255),
//         1);
//   }

//   // Get random animation curve
//   Curve _getRandomCurve() {
//     final curves = [
//       Curves.easeInOut,
//       Curves.bounceOut,
//       Curves.elasticOut,
//       Curves.linearToEaseOut,
//       Curves.fastOutSlowIn
//     ];
//     final random = math.Random();
//     return curves[random.nextInt(curves.length)];
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backGroundColor, // Ensure a clean background
//       body: Stack(
//         children: [
//           // Animated balls in the background
//           for (var ballAnimation in _ballAnimations)
//             AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 // Calculate current position and size
//                 final dx = Tween<double>(
//                         begin: ballAnimation.startX, end: ballAnimation.endX)
//                     .animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: ballAnimation.curve))
//                     .value;

//                 final dy = Tween<double>(
//                         begin: ballAnimation.startY, end: ballAnimation.endY)
//                     .animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: ballAnimation.curve))
//                     .value;

//                 final size = Tween<double>(
//                         begin: ballAnimation.startSize,
//                         end: ballAnimation.endSize)
//                     .animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: ballAnimation.curve))
//                     .value;

//                 // Calculate screen dimensions
//                 final screenWidth = MediaQuery.of(context).size.width;
//                 final screenHeight = MediaQuery.of(context).size.height;

//                 return Positioned(
//                   left: (dx + 1) / 2 * screenWidth,
//                   top: (dy + 1) / 2 * screenHeight,
//                   child: Container(
//                     width: size,
//                     height: size,
//                     decoration: BoxDecoration(
//                       color: ballAnimation.color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 );
//               },
//             ),

//           // Content in the foreground
//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Success!",
//                       style: AppTheme.headingText(secondaryColor).copyWith(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.bold,
//                         // color: Colors.green
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text("Company details have been successfully added with ease and precision",
//                     textAlign: TextAlign.center,)
//                   ],
//                 ),

//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom class to store ball animation properties
// class BallAnimation {
//   final double startX;
//   final double startY;
//   final double endX;
//   final double endY;
//   final double startSize;
//   final double endSize;
//   final Color color;
//   final Curve curve;

//   BallAnimation({
//     required this.startX,
//     required this.startY,
//     required this.endX,
//     required this.endY,
//     required this.startSize,
//     required this.endSize,
//     required this.color,
//     required this.curve,
//   });
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/theme.dart';
import '../../../../core/constants.dart';

class SuccessfullyRegisteredScreen extends StatefulWidget {
  const SuccessfullyRegisteredScreen({Key? key}) : super(key: key);

  @override
  _SuccessfullyRegisteredScreenState createState() =>
      _SuccessfullyRegisteredScreenState();
}

class _SuccessfullyRegisteredScreenState
    extends State<SuccessfullyRegisteredScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _finalAnimationController;
  final List<BallAnimation> _ballAnimations = [];
  late BallAnimation _finalBall;
  bool _showingFinalAnimation = false;
  bool textColor = false;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _startFinalAnimation();
        }
      });

    // Create final animation controller
    _finalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Navigate to next screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>  CustomBottomNavBar(), // Replace with your next screen
            ),
          );
        }
      });

    // Generate multiple balls with random properties
    _generateBalls(15);

    // Start the initial animation
    _animationController.forward();
  }

  void _startFinalAnimation() {
    setState(() {
      _showingFinalAnimation = true;
      // Select a random ball to be the final growing ball
      _finalBall =
          _ballAnimations[math.Random().nextInt(_ballAnimations.length)];
      // Override the color to red
      _finalBall = BallAnimation(
        startX: _finalBall.startX,
        startY: _finalBall.startY,
        endX: _finalBall.endX,
        endY: _finalBall.endY,
        startSize: _finalBall.startSize,
        endSize: _finalBall.endSize,
        color: secondaryColor, // Set red color with slight transparency
        curve: _finalBall.curve,
      );
    });
    _finalAnimationController.forward();
    setState(() {
      textColor = true;
    });
  }

  // void _startFinalAnimation() {
  //   setState(() {
  //     _showingFinalAnimation = true;
  //     // Select a random ball to be the final growing ball
  //     _finalBall = _ballAnimations[math.Random().nextInt(_ballAnimations.length)];
  //   });
  //   _finalAnimationController.forward();
  // }

  void _generateBalls(int count) {
    final random = math.Random();

    for (int i = 0; i < count; i++) {
      // Randomize start and end positions
      final startX = _getRandomOffset();
      final startY = _getRandomOffset();
      final endX = _getRandomOffset();
      final endY = _getRandomOffset();

      // Randomize ball sizes
      final minSize = 20.0;
      final maxSize = 80.0;
      final startSize = minSize + random.nextDouble() * (maxSize - minSize);
      final endSize = minSize + random.nextDouble() * (maxSize - minSize);

      // Randomize color opacity
      final opacity = 0.2 + random.nextDouble() * 0.5;

      final ballAnimation = BallAnimation(
        startX: startX,
        startY: startY,
        endX: endX,
        endY: endY,
        startSize: startSize,
        endSize: endSize,
        color: _getColorVariation(buttonColor).withOpacity(opacity),
        curve: _getRandomCurve(),
      );

      _ballAnimations.add(ballAnimation);
    }
  }

  double _getRandomOffset() => -1 + math.Random().nextDouble() * 2;

  Color _getColorVariation(Color baseColor) {
    final random = math.Random();
    return Color.fromRGBO(
        (baseColor.red + random.nextInt(60) - 25).clamp(0, 255),
        (baseColor.green + random.nextInt(10) - 25).clamp(0, 255),
        (baseColor.blue + random.nextInt(100) - 25).clamp(0, 255),
        1);
  }

  Curve _getRandomCurve() {
    final curves = [
      Curves.easeInOut,
      Curves.bounceOut,
      Curves.elasticOut,
      Curves.linearToEaseOut,
      Curves.fastOutSlowIn
    ];
    return curves[math.Random().nextInt(curves.length)];
  }

  @override
  void dispose() {
    _animationController.dispose();
    _finalAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = math.sqrt(screenSize.width * screenSize.width +
            screenSize.height * screenSize.height) *
        2;

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(
        children: [
          // Regular animated balls
          if (!_showingFinalAnimation)
            for (var ballAnimation in _ballAnimations)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final dx = Tween<double>(
                    begin: ballAnimation.startX,
                    end: ballAnimation.endX,
                  )
                      .animate(CurvedAnimation(
                        parent: _animationController,
                        curve: ballAnimation.curve,
                      ))
                      .value;

                  final dy = Tween<double>(
                    begin: ballAnimation.startY,
                    end: ballAnimation.endY,
                  )
                      .animate(CurvedAnimation(
                        parent: _animationController,
                        curve: ballAnimation.curve,
                      ))
                      .value;

                  final size = Tween<double>(
                    begin: ballAnimation.startSize,
                    end: ballAnimation.endSize,
                  )
                      .animate(CurvedAnimation(
                        parent: _animationController,
                        curve: ballAnimation.curve,
                      ))
                      .value;

                  return _buildBall(context, dx, dy, size, ballAnimation.color);
                },
              ),

          // Final growing ball
          if (_showingFinalAnimation)
            AnimatedBuilder(
              animation: _finalAnimationController,
              builder: (context, child) {
                // Animate the position to center
                final dx = Tween<double>(
                  begin: _finalBall.endX,
                  end: 0.0, // Center X
                )
                    .animate(CurvedAnimation(
                      parent: _finalAnimationController,
                      curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
                    ))
                    .value;

                final dy = Tween<double>(
                  begin: _finalBall.endY,
                  end: 0.0, // Center Y
                )
                    .animate(CurvedAnimation(
                      parent: _finalAnimationController,
                      curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
                    ))
                    .value;

                // Then grow the size
                final size = Tween<double>(
                  begin: _finalBall.endSize,
                  end: maxRadius, // Using maxRadius for full coverage
                )
                    .animate(CurvedAnimation(
                      parent: _finalAnimationController,
                      curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
                    ))
                    .value;

                return Positioned(
                  left: screenSize.width / 2 -
                      size / 2 +
                      (dx * screenSize.width / 2),
                  top: screenSize.height / 2 -
                      size / 2 +
                      (dy * screenSize.height / 2),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: _finalBall.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Success!",
                      style: AppTheme.headingText(
                              textColor ? Colors.white : secondaryColor)
                          .copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Company details have been successfully added with ease and precision",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: textColor ? Colors.white : secondaryColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBall(
      BuildContext context, double dx, double dy, double size, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: (dx + 1) / 2 * screenWidth,
      top: (dy + 1) / 2 * screenHeight,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class BallAnimation {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double startSize;
  final double endSize;
  final Color color;
  final Curve curve;

  BallAnimation({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.startSize,
    required this.endSize,
    required this.color,
    required this.curve,
  });
}

// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:recruiter_app/core/theme.dart';
// import '../../../core/constants.dart';

// class SuccessfullyRegisteredScreen extends StatefulWidget {
//   const SuccessfullyRegisteredScreen({Key? key}) : super(key: key);

//   @override
//   _SuccessfullyRegisteredScreenState createState() =>
//       _SuccessfullyRegisteredScreenState();
// }

// class _SuccessfullyRegisteredScreenState extends State<SuccessfullyRegisteredScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _finalAnimationController;
//   final List<BallAnimation> _ballAnimations = [];
//   late BallAnimation _finalBall;
//   bool _showingFinalAnimation = false;

//   @override
//   void initState() {
//     super.initState();

//     // Create main animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _startFinalAnimation();
//         }
//       });

//     // Create final animation controller
//     _finalAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000), // Increased duration for smoother transition
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           // Navigate to next screen
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => const Navbar(), // Replace with your next screen
//             ),
//           );
//         }
//       });

//     // Generate multiple balls with random properties
//     _generateBalls(15);
    
//     // Start the initial animation
//     _animationController.forward();
//   }

//   void _startFinalAnimation() {
//     setState(() {
//       _showingFinalAnimation = true;
//       // Select a random ball to be the final growing ball
//       _finalBall = _ballAnimations[math.Random().nextInt(_ballAnimations.length)];
//     });
//     _finalAnimationController.forward();
//   }

//   void _generateBalls(int count) {
//     final random = math.Random();

//     for (int i = 0; i < count; i++) {
//       // Randomize start and end positions
//       final startX = _getRandomOffset();
//       final startY = _getRandomOffset();
//       final endX = _getRandomOffset();
//       final endY = _getRandomOffset();

//       // Randomize ball sizes
//       final minSize = 20.0;
//       final maxSize = 80.0;
//       final startSize = minSize + random.nextDouble() * (maxSize - minSize);
//       final endSize = minSize + random.nextDouble() * (maxSize - minSize);

//       // Randomize color opacity
//       final opacity = 0.2 + random.nextDouble() * 0.5;

//       final ballAnimation = BallAnimation(
//         startX: startX,
//         startY: startY,
//         endX: endX,
//         endY: endY,
//         startSize: startSize,
//         endSize: endSize,
//         color: _getColorVariation(buttonColor).withOpacity(opacity),
//         curve: _getRandomCurve(),
//       );

//       _ballAnimations.add(ballAnimation);
//     }
//   }

//   // Your existing helper methods remain the same
//   double _getRandomOffset() => -1 + math.Random().nextDouble() * 2;
//   Color _getColorVariation(Color baseColor) {
//     final random = math.Random();
//     return Color.fromRGBO(
//         (baseColor.red + random.nextInt(60) - 25).clamp(0, 255),
//         (baseColor.green + random.nextInt(10) - 25).clamp(0, 255),
//         (baseColor.blue + random.nextInt(100) - 25).clamp(0, 255),
//         1);
//   }
//   Curve _getRandomCurve() {
//     final curves = [
//       Curves.easeInOut,
//       Curves.bounceOut,
//       Curves.elasticOut,
//       Curves.linearToEaseOut,
//       Curves.fastOutSlowIn
//     ];
//     return curves[math.Random().nextInt(curves.length)];
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _finalAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backGroundColor,
//       body: Stack(
//         children: [
//           // Regular animated balls
//           if (!_showingFinalAnimation)
//             for (var ballAnimation in _ballAnimations)
//               AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (context, child) {
//                   final dx = Tween<double>(
//                     begin: ballAnimation.startX,
//                     end: ballAnimation.endX,
//                   ).animate(CurvedAnimation(
//                     parent: _animationController,
//                     curve: ballAnimation.curve,
//                   )).value;

//                   final dy = Tween<double>(
//                     begin: ballAnimation.startY,
//                     end: ballAnimation.endY,
//                   ).animate(CurvedAnimation(
//                     parent: _animationController,
//                     curve: ballAnimation.curve,
//                   )).value;

//                   final size = Tween<double>(
//                     begin: ballAnimation.startSize,
//                     end: ballAnimation.endSize,
//                   ).animate(CurvedAnimation(
//                     parent: _animationController,
//                     curve: ballAnimation.curve,
//                   )).value;

//                   return _buildBall(context, dx, dy, size, ballAnimation.color);
//                 },
//               ),

//           // Final growing ball
//           if (_showingFinalAnimation)
//             AnimatedBuilder(
//               animation: _finalAnimationController,
//               builder: (context, child) {
//                 final screenWidth = MediaQuery.of(context).size.width;
//                 final screenHeight = MediaQuery.of(context).size.height;
                
//                 // Animate the position to center
//                 final dx = Tween<double>(
//                   begin: _finalBall.endX,
//                   end: 0.0, // Center X
//                 ).animate(CurvedAnimation(
//                   parent: _finalAnimationController,
//                   curve: Interval(0.0, 0.3, curve: Curves.easeInOut), // Move to center in first 30% of animation
//                 )).value;

//                 final dy = Tween<double>(
//                   begin: _finalBall.endY,
//                   end: 0.0, // Center Y
//                 ).animate(CurvedAnimation(
//                   parent: _finalAnimationController,
//                   curve: Interval(0.0, 0.3, curve: Curves.easeInOut), // Move to center in first 30% of animation
//                 )).value;

//                 // Then grow the size
//                 final size = Tween<double>(
//                   begin: _finalBall.endSize,
//                   end: MediaQuery.of(context).size.width * 2,
//                 ).animate(CurvedAnimation(
//                   parent: _finalAnimationController,
//                   curve: Interval(0.3, 1.0, curve: Curves.easeInOut), // Grow after reaching center
//                 )).value;

//                 return Positioned(
//                   left: screenWidth / 2 - size / 2 + (dx * screenWidth / 2),
//                   top: screenHeight / 2 - size / 2 + (dy * screenHeight / 2),
//                   child: Container(
//                     width: size,
//                     height: size,
//                     decoration: BoxDecoration(
//                       color: _finalBall.color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 );
//               },
//             ),

//           // Content
//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Success!",
//                       style: AppTheme.headingText(secondaryColor).copyWith(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       "Company details have been successfully added with ease and precision",
//                       textAlign: TextAlign.center,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBall(BuildContext context, double dx, double dy, double size, Color color) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Positioned(
//       left: (dx + 1) / 2 * screenWidth,
//       top: (dy + 1) / 2 * screenHeight,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }
// class BallAnimation {
//   final double startX;
//   final double startY;
//   final double endX;
//   final double endY;
//   final double startSize;
//   final double endSize;
//   final Color color;
//   final Curve curve;

//   BallAnimation({
//     required this.startX,
//     required this.startY,
//     required this.endX,
//     required this.endY,
//     required this.startSize,
//     required this.endSize,
//     required this.color,
//     required this.curve,
//   });
// }









// 2nd
// class SuccessfullyRegisteredScreen extends StatefulWidget {
//   const SuccessfullyRegisteredScreen({Key? key}) : super(key: key);

//   @override
//   _SuccessfullyRegisteredScreenState createState() =>
//       _SuccessfullyRegisteredScreenState();
// }

// class _SuccessfullyRegisteredScreenState
//     extends State<SuccessfullyRegisteredScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final List<BallAnimation> _ballAnimations = [];
//   late int _highlightedBallIndex;

//   @override
//   void initState() {
//     super.initState();

//     // Create animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           // Navigate to the next screen after a short delay
//           Future.delayed(const Duration(seconds: 1), () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => const NextScreen(), // Replace with your next screen widget
//               ),
//             );
//           });
//         }
//       });

//     // Generate multiple balls with random properties
//     _generateBalls(15);

//     // Highlight one ball to grow bigger
//     _highlightedBallIndex = math.Random().nextInt(_ballAnimations.length);

//     // Start the animation
//     _animationController.forward();
//   }

//   void _generateBalls(int count) {
//     final random = math.Random();

//     for (int i = 0; i < count; i++) {
//       final startX = _getRandomOffset();
//       final startY = _getRandomOffset();
//       final endX = _getRandomOffset();
//       final endY = _getRandomOffset();
//       final minSize = 20.0;
//       final maxSize = 80.0;
//       final startSize = minSize + random.nextDouble() * (maxSize - minSize);
//       final endSize = minSize + random.nextDouble() * (maxSize - minSize);
//       final opacity = 0.2 + random.nextDouble() * 0.5;

//       final ballAnimation = BallAnimation(
//         startX: startX,
//         startY: startY,
//         endX: endX,
//         endY: endY,
//         startSize: startSize,
//         endSize: endSize,
//         color: _getColorVariation(buttonColor).withOpacity(opacity),
//         curve: _getRandomCurve(),
//       );

//       _ballAnimations.add(ballAnimation);
//     }
//   }

//   double _getRandomOffset() {
//     final random = math.Random();
//     return -1 + random.nextDouble() * 2;
//   }

//   Color _getColorVariation(Color baseColor) {
//     final random = math.Random();
//     return Color.fromRGBO(
//         (baseColor.red + random.nextInt(60) - 25).clamp(0, 255),
//         (baseColor.green + random.nextInt(10) - 25).clamp(0, 255),
//         (baseColor.blue + random.nextInt(100) - 25).clamp(0, 255),
//         1);
//   }

//   Curve _getRandomCurve() {
//     final curves = [
//       Curves.easeInOut,
//       Curves.bounceOut,
//       Curves.elasticOut,
//       Curves.linearToEaseOut,
//       Curves.fastOutSlowIn
//     ];
//     final random = math.Random();
//     return curves[random.nextInt(curves.length)];
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backGroundColor,
//       body: Stack(
//         children: [
//           for (int i = 0; i < _ballAnimations.length; i++)
//             AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 final dx = Tween<double>(
//                         begin: _ballAnimations[i].startX,
//                         end: _ballAnimations[i].endX)
//                     .animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: _ballAnimations[i].curve))
//                     .value;

//                 final dy = Tween<double>(
//                         begin: _ballAnimations[i].startY,
//                         end: _ballAnimations[i].endY)
//                     .animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: _ballAnimations[i].curve))
//                     .value;

//                 final size = (i == _highlightedBallIndex)
//                     ? Tween<double>(
//                             begin: _ballAnimations[i].startSize,
//                             end: _ballAnimations[i].endSize * 3)
//                         .animate(CurvedAnimation(
//                             parent: _animationController,
//                             curve: Curves.fastOutSlowIn))
//                         .value
//                     : Tween<double>(
//                             begin: _ballAnimations[i].startSize,
//                             end: _ballAnimations[i].endSize)
//                         .animate(CurvedAnimation(
//                             parent: _animationController,
//                             curve: _ballAnimations[i].curve))
//                         .value;

//                 final screenWidth = MediaQuery.of(context).size.width;
//                 final screenHeight = MediaQuery.of(context).size.height;

//                 return Positioned(
//                   left: (dx + 1) / 2 * screenWidth,
//                   top: (dy + 1) / 2 * screenHeight,
//                   child: Container(
//                     width: size,
//                     height: size,
//                     decoration: BoxDecoration(
//                       color: _ballAnimations[i].color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           SafeArea(
//             child: Center(
//               child: Text(
//                 "Success!",
//                 style: AppTheme.headingText(secondaryColor).copyWith(
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BallAnimation {
//   final double startX;
//   final double startY;
//   final double endX;
//   final double endY;
//   final double startSize;
//   final double endSize;
//   final Color color;
//   final Curve curve;

//   BallAnimation({
//     required this.startX,
//     required this.startY,
//     required this.endX,
//     required this.endY,
//     required this.startSize,
//     required this.endSize,
//     required this.color,
//     required this.curve,
//   });
// }

// // Replace with your next screen
// class NextScreen extends StatelessWidget {
//   const NextScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("Welcome to the Next Screen!")),
//     );
//   }
// }
