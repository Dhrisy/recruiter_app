import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/navbar/view_model/navbar_viewmodel.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Load theme preference before running the app
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;


  runApp(MyApp(initialThemeMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppThemeDataBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    
    // Initialize the theme bloc with the initial theme mode
    _themeBloc = AppThemeDataBloc();
    

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _themeBloc.add(ChangeTheme(isDarkMode: widget.initialThemeMode));
    
    // Add a listener to track state changes
    _themeBloc.stream.listen((state) {
      print("Theme state updated: ${state.isDarkMode}");
    });
  });

   

 
  }

  @override
  void dispose() {
    _themeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjust as per your design requirement
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavBarBloc()),
          BlocProvider.value(value: _themeBloc)
        ],
        child: BlocBuilder<AppThemeDataBloc, AppThemeDataState>(
          bloc: _themeBloc,
          builder: (context, state) {
            return MaterialApp(
              title: 'Recruiter',
              debugShowCheckedModeBanner: false,
              theme: state.isDarkMode
                  ? RecruiterAppTheme.darkTheme
                  : RecruiterAppTheme.lightTheme,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}