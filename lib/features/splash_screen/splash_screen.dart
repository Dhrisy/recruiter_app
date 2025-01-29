import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/auth/view/login_screen.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/navbar/view/navbar.dart';
import 'package:recruiter_app/features/onboarding/onboarding.dart';
import 'package:recruiter_app/features/onboarding/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
  bool _isLoogedIn = false;
  bool isInstalled = false;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    _checkLoginStatus();

    // Navigate to the next screen after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print(_isLoogedIn);
        print(_isLoogedIn == false && isInstalled == true);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _isLoogedIn
                ? CustomBottomNavBar() 
                : _isLoogedIn == false && isInstalled == true
                ? LoginScreen()
               : LandingScreen(),
            // const LandingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration:
                const Duration(milliseconds: 800), // Smoother transition
          ),
        );
      }
    });
  }

  void _checkLoginStatus() async {
       final _storage = FlutterSecureStorage();
       final installed = await _storage.read(key: "user");
    
    _isLoogedIn = await isLoggedIn();
    isInstalled = installed != null ? true : false;
    setState(() {});
  }

  Future<bool> isLoggedIn() async {
 
    final token = await CustomFunctions().retrieveCredentials("access_token");
    final _token = await CustomFunctions().retrieveCredentials("refresh_token");

    print(token);
    print("refresh $_token");
    
   if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: buttonColor,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOpen = !_isOpen;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: _isOpen ? 300.0 : 150.0,
                    height: _isOpen ? 300.0 : 150.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FadeTransition(
                        opacity: _animation, // Fade out the logo
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
