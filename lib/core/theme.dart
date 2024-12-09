import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recruiter_app/core/constants.dart';

class AppTheme {
  // Define heading text style
  static TextStyle headingText(Color color) {
    return GoogleFonts.beVietnamPro(
      fontSize: headingFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle titleText(Color color) {
    return GoogleFonts.beVietnamPro(
      fontSize: titleFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }


  static TextStyle bodyText(Color color) {
    return GoogleFonts.beVietnamPro(
      fontSize: mediumSmallFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

   static TextStyle smallText(Color color) {
    return GoogleFonts.beVietnamPro(
      fontSize: smallTextFont, // Ensure this is defined as a constant
      color: color,
      fontWeight: FontWeight.normal,
    );
  }
}
