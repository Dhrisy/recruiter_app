import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/jobpost_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/search_job_provider.dart';
import 'package:recruiter_app/features/navbar/view_model/navbar_viewmodel.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_bloc.dart';
import 'package:recruiter_app/features/questionaires/data/questionaire_repository.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';


int retryCount = 0;
  int maxRetries = 3;
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
      designSize: const Size(360, 690),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginProvider(authRepository: AuthRepository())),
          ChangeNotifierProvider(create: (context) => AccountProvider()),
          ChangeNotifierProvider(create: (context) => SearchSeekerProvider()),
          ChangeNotifierProvider(create: (context) => SearchJobProvider())
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavBarBloc()),
            BlocProvider.value(value: _themeBloc),
            BlocProvider(create: (context) => AuthBloc(AuthRepository())),
            BlocProvider(create: (context) => QuestionaireBloc(QuestionaireRepository())),
            BlocProvider(create: (context) => JobPostBloc(JobPostRepository())),
            BlocProvider(create: (context) => JobBloc(JobPostRepository())),

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
      ),
    );
  }
}