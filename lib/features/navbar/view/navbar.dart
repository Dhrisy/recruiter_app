import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/navbar/view_model/navbar_viewmodel.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }
  

  @override
  Widget build(BuildContext context) {
    final NavBarBloc navBarBloc = BlocProvider.of<NavBarBloc>(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            Center(
              child: Text("Home"),
            ),
            Center(
              child: Text("rofilw"),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<NavBarBloc, NavBarState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: WaterDropNavBar(
                  backgroundColor: Colors.transparent,
                  bottomPadding: 20,
                  onItemSelected: (index) {
                    // setState(() {
                    //   selectedIndex = index;
                    // });
                    navBarBloc.add(ChangeIndex(currentIndex: index));
                    print(state.currentIndex);
                    
                    pageController.animateToPage(state.currentIndex,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutQuad);
                  },
                  selectedIndex: state.currentIndex,
                  barItems: [
                    BarItem(
                      filledIcon: Icons.bookmark_rounded,
                      outlinedIcon: Icons.bookmark_border_rounded,
                    ),
                    BarItem(
                        filledIcon: Icons.favorite_rounded,
                        outlinedIcon: Icons.favorite_border_rounded),
                  ],
                ),
              );
            }
          ),
        ),
      )),
    );
  }
}
