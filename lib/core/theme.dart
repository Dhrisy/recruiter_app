import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/constants.dart';

class AppTheme {
  // Define heading text style
   static TextStyle headingLarge(Color? color) {
    return GoogleFonts.beVietnamPro(
      fontSize: 28.sp, // Ensure this is defined as a constant
      color: color ?? lightTextColor,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headingText(Color? color) {
    return GoogleFonts.beVietnamPro(
      fontSize: headingFont, // Ensure this is defined as a constant
      color: color ?? lightTextColor,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleText(Color color) {
    return GoogleFonts.montserrat(
      fontSize: titleFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle mediumTitleText(Color color) {
    return GoogleFonts.montserrat(
      fontSize: mediumTitleFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bodyText(Color color) {
    return GoogleFonts.montserrat(
      fontSize: mediumSmallFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle smallText(Color color) {
    return GoogleFonts.wixMadeforDisplay(
      fontSize: smallTextFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }
}

class RecruiterAppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: lightScaffoldBackground,
    primaryColor: buttonColor,
    primaryColorDark: buttonColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightAppBackgroundColor,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      headlineMedium: AppTheme.headingText(lightTextColor),
      headlineLarge: AppTheme.headingLarge(lightTextColor),
      titleLarge: AppTheme.titleText(lightTextColor),
      titleMedium: AppTheme.mediumTitleText(lightTextColor),
      bodyMedium: AppTheme.smallText(lightTextColor),
      bodyLarge: AppTheme.mediumTitleText(lightTextColor),
      bodySmall: AppTheme.smallText(lightTextColor)


      ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkScaffoldBackground,
    primaryColor: buttonColor,
    primaryColorDark: buttonColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkAppBackgroundColor,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      headlineMedium: AppTheme.headingText(darkTextColor),
       headlineLarge: AppTheme.headingLarge(darkTextColor),
       titleLarge: AppTheme.titleText(darkTextColor),
       titleMedium: AppTheme.mediumTitleText(darkTextColor),
      bodyMedium: AppTheme.smallText(darkTextColor),
      bodyLarge: AppTheme.mediumTitleText(darkTextColor),
      bodySmall: AppTheme.smallText(darkTextColor)
      ),
  );
}
