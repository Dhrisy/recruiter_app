import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


// color
const  buttonColor =    Color(0xffFA7754);
const  backGroundColor =    Colors.white;
const  secondaryColor =    Color(0xff312651);




// fontsize
final headingFont = 25.sp;
final mediumHeadingFont = 18.sp;
final titleFont = 16.sp;
final bodyMediumTitleFont = 14.sp;
final mediumTitleFont = 15.sp;
final mediumSmallFont = 13.sp;
final smallTextFont = 12.sp;

// fontWeight
FontWeight titleFontWeight = FontWeight.bold;
FontWeight normalFontWeight = FontWeight.normal;

// radius
final borderRadius = 15.r;



class AppTheme {
 static TextStyle headingText(Color color) {
    return GoogleFonts.beVietnamPro(
      fontSize: headingFont,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }
}



