
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:recruiter_app/core/utils/navigation_animation.dart';
// import 'package:recruiter_app/features/account/account.dart';
// import 'package:recruiter_app/core/constants.dart';
// import 'package:recruiter_app/features/home/view/home_screen.dart';
// import 'package:recruiter_app/features/resdex/resedex.dart';
// import 'package:recruiter_app/features/responses/view/response.dart';

// class Navbar extends StatefulWidget {
//   final int? index;
//   const Navbar({Key? key, this.index}) : super(key: key);

//   @override
//   _NavbarState createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   List<Widget> screens = [HomeScreen(), Resedex(), Response(), Account()];
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 4, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       if(widget.index != null){
//         setState(() {
//           currentIndex = widget.index!;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[currentIndex],
     
//       bottomNavigationBar: _buildBottomNavBarWidget(),
//    );
//   }

//   Widget _buildBottomNavBarWidget() {
//     return Container(
//       height: 90.h,
//       width: double.infinity,
//       color: Colors.transparent,
//       // decoration: BoxDecoration(
//       //     color: Colors.transparent,
//       //     borderRadius: BorderRadius.circular(15.r),
//       //     boxShadow: [
//       //       BoxShadow(
//       //           blurRadius: 6.r, color: borderColor, offset: const Offset(1, 1))
//       //     ]),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 70.h,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15.r),
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 6.r,
//                         color: borderColor,
//                         offset: const Offset(1, 1))
//                   ]),
//               child: Padding(
//                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildNavBarItem(
//                         text: "Home",
//                         icon: currentIndex == 0
//                             ? Icons.home
//                             : Icons.home_outlined,
//                         index: 0),
//                     _buildNavBarItem(
//                         text: "Resdex",
//                         icon: currentIndex == 1
//                             ? Icons.person_search
//                             : Icons.person_search_outlined,
//                         index: 1),
//                     _buildNavBarItem(
//                         text: "Response",
//                         icon:
//                             currentIndex == 2 ? Icons.work : Icons.work_outline,
//                         index: 2),
//                     _buildNavBarItem(
//                         text: "Response",
//                         icon: currentIndex == 3
//                             ? Icons.account_circle
//                             : Icons.account_circle_outlined,
//                         index: 3),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: FloatingActionButton(
//                 onPressed: () {
//                   Navigator.push(context, AnimatedNavigation().slideAnimation(JobPostForm()));
//                 },
//                 child: Icon(Icons.add),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavBarItem(
//       {required String text, required IconData icon, required int index}) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           currentIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.all(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedSize(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               child: Icon(
//                 icon,
//                 size: currentIndex == index ? 28.sp : 25.sp,
//                 color: currentIndex == index ? buttonColor : greyTextColor,
//               ),
//             ),
//             if (currentIndex == index)
//               AnimatedOpacity(
//                 opacity: currentIndex == index ? 1.0 : 0.0,
//                 duration: Duration(milliseconds: 300),
//                 child: Text(
//                   text,
//                   style: TextStyle(
//                     color: currentIndex == index ? buttonColor : greyTextColor,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//     // return InkWell(
//     //   onTap: () {
//     //     setState(() {
//     //       currentIndex = index;
//     //     });
//     //   },
//     //   child: SizedBox(
//     //     child: Column(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       children: [
//     //         Icon(
//     //           icon,
//     //           size: currentIndex == index ? 28.sp : 25.sp,
//     //           color: currentIndex == index ? buttonColor : greyTextColor,
//     //         ),
//     //       currentIndex == index ?  Text(text) : const SizedBox.shrink()
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
// }
