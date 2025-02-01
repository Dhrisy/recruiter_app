import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account.dart';
import 'package:recruiter_app/features/home/view/home_screen.dart';
import 'package:recruiter_app/features/job_post/view/job_form.dart';
import 'package:recruiter_app/features/resdex/resedex.dart';
import 'package:recruiter_app/features/responses/view/response.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int? index;

  const CustomBottomNavBar({super.key, this.index});
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _activeIndex = 0;

  final List<Widget> _icons = [
    Icon(
      Icons.home,
    ),
    Container(
      height: 30,
      width: 30,
      child: SvgPicture.asset(
        "assets/svgs/resdex_fill.svg",
        fit: BoxFit.cover,
      ),
    ),
    Container(
      height: 30,
      width: 30,
      child: SvgPicture.asset(
        "assets/svgs/response_filled.svg",
        fit: BoxFit.cover,
      ),
    ),
    Icon(
      Icons.business,
    ),
  ];

  List<Widget> screens = [HomeScreen(), Resedex(), Response(), Account()];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        setState(() {
          _activeIndex = widget.index!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: screens[_activeIndex],
        floatingActionButton: FloatingActionButton(
          heroTag: "add_fab",
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () async {
            final token =
                await CustomFunctions().retrieveCredentials("access_token");
            print(token);
            Navigator.push(
                context, AnimatedNavigation().fadeAnimation(const JobForm()));
          },
          backgroundColor: secondaryColor,
          child: const Icon(
            Icons.add,
            size: 32,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          height: 65,
          itemCount: screens.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? secondaryColor : buttonColor;

            final List<Widget> _icons = [
              // Icon(
              //   Icons.home,
              //   color: color,
              // ),
              Container(
                height: 30,
                width: 30,
                child: SvgPicture.asset(
                  "assets/svgs/home_fill.svg",
                  fit: BoxFit.cover,
                  color: color,
                ),
              ),
              Container(
                height: 30,
                width: 30,
                child: SvgPicture.asset(
                  "assets/svgs/resdex_fill.svg",
                  fit: BoxFit.cover,
                  color: color,
                ),
              ),
              Container(
                height: 30,
                width: 30,
                child: SvgPicture.asset(
                  "assets/svgs/response_filled.svg",
                  fit: BoxFit.cover,
                  color: color,
                ),
              ),
              Container(
                height: 30,
                width: 30,
                child: SvgPicture.asset(
                  "assets/svgs/account_filled.svg",
                  fit: BoxFit.cover,
                  color: color,
                ),
              ),
              // Icon(
              //   Icons.business,
              //   color: color,
              // ),
            ];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _icons[index],
                isActive
                    ? Text(
                        ['Home', 'Resdex', 'Response', 'Account'][index],
                        style: TextStyle(color: color, fontSize: 12),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
          activeIndex: _activeIndex,
          shadow: BoxShadow(
              blurRadius: 8.r, color: borderColor, offset: const Offset(1, 1)),
          // borderColor: borderColor,
          blurEffect: true,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          backgroundGradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.white, Colors.white],
          ),
          // colors: [Colors.white, Color.fromARGB(255, 237, 155, 132)]),
          leftCornerRadius: 30,
          rightCornerRadius: 30,
          onTap: (index) {
            setState(() {
              _activeIndex = index;
            });
          },
          splashSpeedInMilliseconds: 1,
        ),
      ),
    );
  }

  // bottomNavigationBar: AnimatedBottomNavigationBar(

  //   icons: _icons,
  //   activeIndex: _activeIndex,
  //   gapLocation: GapLocation.center,
  //   notchSmoothness: NotchSmoothness.softEdge,
  //   backgroundColor: Colors.pink.shade50,
  //   activeColor: Colors.purple,
  //   inactiveColor: Colors.grey,
  //   iconSize: 28,
  //   leftCornerRadius: 30,
  //   rightCornerRadius: 30,
  //   onTap: (index) {
  //     setState(() {
  //       _activeIndex = index;
  //     });
  //   },
  // ),
//       ),
//     );
//   }
}

// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:recruiter_app/core/constants.dart';
// import 'package:recruiter_app/features/account/account.dart';
// import 'package:recruiter_app/features/home/view/home_screen.dart';
// import 'package:recruiter_app/features/resdex/resedex.dart';
// import 'package:recruiter_app/features/responses/view/response.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   @override
//   _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   int _activeIndex = 0;

//   final List<Widget> _customIcons = [
//     Container(
//       height: 35,
//       width: 35,
//       child: SvgPicture.asset(
//         "assets/svgs/home.svg",
//         fit: BoxFit.cover,
//       ),
//     ),
//     Container(
//       height: 30,
//       width: 30,
//       child: SvgPicture.asset(
//         "assets/svgs/resdex.svg",
//         fit: BoxFit.cover,
//       ),
//     ),
//     Container(
//       height: 30,
//       width: 30,
//       child: SvgPicture.asset(
//         "assets/svgs/response.svg",
//         fit: BoxFit.cover,
//       ),
//     ),
//     Container(
//       height: 30,
//       width: 30,
//       child: SvgPicture.asset(
//         "assets/svgs/account.svg",
//         fit: BoxFit.cover,
//       ),
//     ),
//     // SvgPicture.asset("assets/svgs/resdex_fill.svg"),
//     // SvgPicture.asset("assets/svgs/response_filled.svg"),
//     // SvgPicture.asset("assets/svgs/account_filled.svg")
//   ];
//   List<Widget> screens = [HomeScreen(), Resedex(), Response(), Account()];

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: screens[_activeIndex],
//         floatingActionButton: FloatingActionButton(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//           onPressed: () {
//             // Handle action when FAB is clicked
//           },
//           backgroundColor: Colors.purple,
//           child: Icon(Icons.home, size: 32),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: AnimatedBottomNavigationBar.builder(
//           height: 65,
//           itemCount: _customIcons.length,
//           tabBuilder: (int index, bool isActive) {
//             final color = isActive ? secondaryColor : buttonColor;
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _customIcons[index],
//                 Text(
//                   ['Home', 'Search', 'Favorites', 'Settings'][index],
//                   style: TextStyle(color: color, fontSize: 12),
//                 ),
//               ],
//             );
//           },
//           activeIndex: _activeIndex,
//           gapLocation: GapLocation.center,
//           notchSmoothness: NotchSmoothness.softEdge,
//           backgroundColor: buttonColor,
//           leftCornerRadius: 30,
//           rightCornerRadius: 30,
//           onTap: (index) {
//             setState(() {
//               _activeIndex = index;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
