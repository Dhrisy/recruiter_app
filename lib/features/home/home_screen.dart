import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _themeBloc = context.read<AppThemeDataBloc>();
    return Material(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: secondaryColor,
        // ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17.h,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(),
                    child: SvgPicture.asset(
                      "assets/svgs/home_top_widget.svg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  _buildAppBarWidget(themeBloc: _themeBloc, theme: theme)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarWidget({required AppThemeDataBloc themeBloc, required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text("asdfghj"),
                      Text("asdfghj"),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                      child: SvgPicture.asset(
                    "assets/svgs/notification_icon.svg",
                  ))
                ],
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: themeBloc.state.isDarkMode
                  ? darkContainerColor
                  : lightContainerColor,
              borderRadius: BorderRadius.circular(15.r),
              // border: Border.all(color: secondaryColor),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: theme.textTheme.bodyLarge,
                filled: true,
                fillColor: themeBloc.state.isDarkMode
                    ? darkContainerColor
                    : lightContainerColor,
                suffixIcon: Icon(CupertinoIcons.search),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: secondaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: secondaryColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: secondaryColor)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
