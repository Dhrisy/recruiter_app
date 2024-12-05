import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/onboarding/onboarding2.dart';
import 'package:recruiter_app/main.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1>
    {
 

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_){
    Future.delayed(Duration(seconds: 2), (){
       Navigator.pushReplacement(
          context,
          AnimatedNavigation().fadeAnimation(Onboarding2())
        );
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage("assets/images/onboard1_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildWelcomeContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Column(
        children: [
          Text(
            "Welcome to Recruiter !",
            style: GoogleFonts.caprasimo(fontSize: 25.sp, color: Colors.white),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "A one-stop platform for buying and selling businesses,plots,and real estate properties, offering convenience",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
