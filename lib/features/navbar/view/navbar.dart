// import 'package:flutter/material.dart';
// import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:recruiter_app/account/account.dart';
// import 'package:recruiter_app/features/home/view/home_screen.dart';

// class Navbar extends StatefulWidget {
//   const Navbar({Key? key}) : super(key: key);

//   @override
//   _NavbarState createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   List<Widget> screens = [HomeScreen(), Account()];
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Material(
//           child: BottomBar(
//             barColor: Colors.white,
//             fit: StackFit.expand,
//             icon: (width, height) => Center(
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.arrow_upward_rounded,
//                   size: width,
//                 ),
//               ),
//             ),
//             borderRadius: BorderRadius.circular(0),
//             duration: const Duration(seconds: 1),
//             curve: Curves.decelerate,
//             showIcon: true,
//             width: double.infinity, // Set width to double.infinity
//             start: 0,
//             end: 0,
//             offset: 0,
//             // barAlignment: Alignment.bottomCenter,
//             iconHeight: 35,
//             iconWidth: 35,
//             reverse: false,
//             barDecoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(500),
//             ),
//             iconDecoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(500),
//             ),
//             hideOnScroll: true,
//             scrollOpposite: false,
//             onBottomBarHidden: () {},
//             onBottomBarShown: () {},
//             body: (context, controller) => TabBarView(
//               controller: tabController,
//               physics: const BouncingScrollPhysics(),
//               children: screens,
//             ),
//             child: TabBar(
//               controller: tabController,
//               indicatorColor: Colors.transparent,
//               dividerHeight: 0,

//               tabs: const [
//                 Tab(icon: Icon(Icons.home), text: "Home"),
//                 Tab(icon: Icon(Icons.person), text: "Account"),
//               ],
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: FloatingActionButton(
//             onPressed: () {
//               // Add your FAB action here
//               print("FAB Clicked");
//             },
//             backgroundColor: Colors.blue,
//             child: const Icon(Icons.add, color: Colors.white),
//           ),
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/account/account.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/home/view/home_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Widget> screens = [HomeScreen(), Account()];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: BottomBar(
            barColor: Colors.transparent, // Color(0xffFFF4F2),
            fit: StackFit.expand,

            borderRadius: BorderRadius.circular(0),
            duration: const Duration(seconds: 1),
            curve: Curves.decelerate,
            showIcon: true,
            width: double.infinity, // Set width to double.infinity
            start: 0,
            end: 0,
            offset: 0,
            iconHeight: 25,
            iconWidth: 35,
            reverse: false,
            barDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            iconDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            hideOnScroll: true,
            scrollOpposite: false,
            onBottomBarHidden: () {},
            onBottomBarShown: () {},
            body: (context, controller) => TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(),
              children: screens,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 201, 200, 200),
                      blurRadius: 1.r,
                      offset: const Offset(0, -5)
                    )
                  ],
                    border:
                        BorderDirectional(top: BorderSide(color: borderColor))),
                child: TabBar(
                  controller: tabController,
                  
                  indicatorColor:
                      Colors.transparent, // Set a valid indicator color
                  // indicatorWeight: 3, // Set indicator weight greater than 0
                  dividerHeight: 0,
                  dividerColor: Colors.black, // Divider color

                  tabs: const [
                    Tab(icon: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.home),
                    ), text: "Home"),
                    Tab(icon: Padding(
                       padding: EdgeInsets.only(top: 10),
                      child: Icon(Icons.person),
                    ), text: "Account"),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.06),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
