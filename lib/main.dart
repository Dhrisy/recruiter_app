import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/theme.dart';
import 'package:recruiter_app/core/utils/app_theme_data.dart';
import 'package:recruiter_app/core/utils/custom_functions.dart';
import 'package:recruiter_app/features/account/account_provider.dart';
import 'package:recruiter_app/features/auth/bloc/auth_bloc.dart';
import 'package:recruiter_app/features/auth/data/auth_repository.dart';
import 'package:recruiter_app/features/auth/provider/login_provider.dart';
import 'package:recruiter_app/features/details/job_details_provider.dart';
import 'package:recruiter_app/features/home/viewmodel/home_provider.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/job_posting_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/jobpost_provider.dart';
import 'package:recruiter_app/features/job_post/viewmodel.dart/search_job_provider.dart';
import 'package:recruiter_app/features/navbar/view/animated_navbar.dart';
import 'package:recruiter_app/features/navbar/view_model/navbar_viewmodel.dart';
import 'package:recruiter_app/features/notifications/notification_provider.dart';
import 'package:recruiter_app/features/plans/viewmodel/plans_provider.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_bloc.dart';
import 'package:recruiter_app/features/questionaires/data/questionaire_repository.dart';
import 'package:recruiter_app/features/resdex/provider/email_template_provider.dart';
import 'package:recruiter_app/features/resdex/provider/interview_provider.dart';
import 'package:recruiter_app/features/resdex/provider/search_seeker_provider.dart';
import 'package:recruiter_app/features/responses/provider/seeker_provider.dart';
import 'package:recruiter_app/features/seeker_details/invite_seeker_provider.dart';
import 'package:recruiter_app/features/settings/viewmodel/settings_provider.dart';
import 'package:recruiter_app/features/splash_screen/splash_screen.dart';
import 'package:recruiter_app/services/one_signal_service.dart';
import 'package:recruiter_app/viewmodels/job_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

int retryCount = 0;
int maxRetries = 3;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   // Load theme preference before running the app
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

//   OneSignal.initialize("f57460e6-1f9e-418a-ab47-c499dce28870");
//   OneSignal.Notifications.requestPermission(true);

//   // Add basic notification handler
//   OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//     print("NOTIFICATION RECEIVED: ${event.notification.title}");
//     // Actually display the notification
//     event.notification.display();
//   });

//   try {
//     // Get device token
//     final deviceToken =  OneSignal.User.pushSubscription.token;
//     print("OneSignal Device Token: $deviceToken");

//     final isSubscribed = OneSignal.User.pushSubscription.optedIn;
//     print("User is subscribed: $isSubscribed");

//     // Get user ID
//     String? userId = await OneSignal.User.pushSubscription.id;
//     print("OneSignal User ID: $userId");

//     // Save device token and user ID into secure storage
//     if (deviceToken != null) {
//       await CustomFunctions().storeCredentials("one_signal_id", deviceToken);
//       print("Device token saved successfully.");
//     }

//     if (userId != null) {
//       await CustomFunctions().storeCredentials("one_signal_userid", userId);
//       final id =
//           await CustomFunctions().retrieveCredentials("one_signal_userid");
//       print("signa id $id");
//       await OneSignalService.oneSignalService(oneSignalId: id ?? "");
//       print("User ID saved successfully.");
//     }
//   } catch (e) {
//     print("Error occurred while retrieving or saving OneSignal data: $e");
//   }

//   runApp(MyApp(initialThemeMode: isDarkMode));
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // Load theme preference before running the app
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose); // Enable debug logs
  OneSignal.initialize("f57460e6-1f9e-418a-ab47-c499dce28870");

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
          ChangeNotifierProvider(
              create: (context) =>
                  LoginProvider(authRepository: AuthRepository())),
          ChangeNotifierProvider(create: (context) => AccountProvider()),
          ChangeNotifierProvider(create: (context) => SearchSeekerProvider()),
          ChangeNotifierProvider(create: (context) => SearchJobProvider()),
          ChangeNotifierProvider(create: (context) => SeekerProvider()),
          ChangeNotifierProvider(create: (context) => EmailTemplateProvider()),
          ChangeNotifierProvider(create: (context) => InviteSeekerProvider()),
          ChangeNotifierProvider(create: (context) => InterviewProvider()),
          ChangeNotifierProvider(create: (context) => JobDetailsProvider()),
          ChangeNotifierProvider(create: (context) => JobPostingProvider()),
          ChangeNotifierProvider(create: (context) => HomeProvider()),
          ChangeNotifierProvider(create: (context) => SettingsProvider()),
          ChangeNotifierProvider(create: (context) => PlanProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavBarBloc()),
            BlocProvider.value(value: _themeBloc),
            BlocProvider(create: (context) => AuthBloc(AuthRepository())),
            BlocProvider(
                create: (context) =>
                    QuestionaireBloc(QuestionaireRepository())),
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
                home: SplashScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
