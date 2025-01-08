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
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/account/account.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/home/view/home_screen.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/view/job_post_form.dart';
import 'package:recruiter_app/features/job_post/view/preview_job.dart';
import 'package:recruiter_app/features/resdex/resedex.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Widget> screens = [HomeScreen(), Resedex(), Account(), Account()];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: _buildBottomNavBarWidget(),
      //  Stack(
      //   children: [
      //     Material(
      //       child: BottomBar(
      //         barColor: Colors.transparent, // Color(0xffFFF4F2),
      //         fit: StackFit.expand,

      //         borderRadius: BorderRadius.circular(0),
      //         duration: const Duration(seconds: 1),
      //         curve: Curves.decelerate,
      //         showIcon: true,
      //         width: double.infinity,
      //         start: 0,
      //         end: 0,
      //         offset: 0,
      //         iconHeight: 25,
      //         iconWidth: 35,
      //         reverse: false,
      //         barDecoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(500),
      //         ),
      //         iconDecoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(500),
      //         ),
      //         hideOnScroll: true,
      //         scrollOpposite: false,
      //         onBottomBarHidden: () {},
      //         onBottomBarShown: () {},
      //         body: (context, controller) => TabBarView(
      //           controller: tabController,
      //           physics: const BouncingScrollPhysics(),
      //           children: screens,
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.only(bottom: 0),
      //           child: Container(
      //             height: 60.h,
      //             decoration: BoxDecoration(
      //                 color: Colors.red,
      //                 boxShadow: [
      //                   BoxShadow(
      //                       color: const Color.fromARGB(255, 201, 200, 200),
      //                       blurRadius: 1.r,
      //                       offset: const Offset(0, -5))
      //                 ],
      //                 border: BorderDirectional(
      //                     top: BorderSide(color: borderColor))),
      //             child: TabBar(
      //               controller: tabController,
      //               indicatorColor: Colors.transparent,
      //               dividerHeight: 0,
      //               dividerColor: Colors.black,
      //               tabs: const [
      //                 Tab(
      //                     icon: Padding(
      //                       padding: EdgeInsets.only(top: 10),
      //                       child: Icon(Icons.home),
      //                     ),
      //                     text: "Home"),
      //                 Tab(
      //                     icon: Padding(
      //                       padding: EdgeInsets.only(top: 10),
      //                       child: Icon(Icons.search),
      //                     ),
      //                     text: "Resdex"),
      //                 Tab(
      //                     icon: Padding(
      //                       padding: EdgeInsets.only(top: 10),
      //                       child: Icon(Icons.search),
      //                     ),
      //                     text: "Resdex"),
      //                 Tab(
      //                     icon: Padding(
      //                       padding: EdgeInsets.only(top: 10),
      //                       child: Icon(Icons.business),
      //                     ),
      //                     text: "Account"),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Padding(
      //         padding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).size.height * 0.06),
      //         child: FloatingActionButton(
      //           onPressed: () async {
      //             Navigator.push(context,
      //                 AnimatedNavigation().fadeAnimation(const JobPostForm()));
      //           },
      //           backgroundColor: buttonColor,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(50.r)),
      //           child: const Icon(Icons.add, color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildBottomNavBarWidget() {
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: [
        BoxShadow(
          blurRadius: 6.r,
          color: borderColor,
          offset: const Offset(1, 1)
        )
      ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavBarItem(
                text: "Home",
                icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                index: 0),
            _buildNavBarItem(
                text: "Resdex",
                icon: currentIndex == 1
                    ? Icons.person_search
                    : Icons.person_search_outlined,
                index: 1),
            _buildNavBarItem(
                text: "Response",
                icon: currentIndex == 2 ? Icons.work : Icons.work_outline,
                index: 2),
            _buildNavBarItem(
                text: "Response",
                icon: currentIndex == 3
                    ? Icons.account_circle
                    : Icons.account_circle_outlined,
                index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
      {required String text, required IconData icon, required int index}) {
        return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                size: currentIndex == index ? 28.sp : 25.sp,
                color: currentIndex == index ? buttonColor : greyTextColor,
              ),
            ),
            if (currentIndex == index)
              AnimatedOpacity(
                opacity: currentIndex == index ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  text,
                  style: TextStyle(
                    color: currentIndex == index ? buttonColor : greyTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    // return InkWell(
    //   onTap: () {
    //     setState(() {
    //       currentIndex = index;
    //     });
    //   },
    //   child: SizedBox(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           icon,
    //           size: currentIndex == index ? 28.sp : 25.sp,
    //           color: currentIndex == index ? buttonColor : greyTextColor,
    //         ),
    //       currentIndex == index ?  Text(text) : const SizedBox.shrink()
    //       ],
    //     ),
    //   ),
    // );
  }
}
