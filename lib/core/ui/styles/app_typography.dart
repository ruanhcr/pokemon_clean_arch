import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';

abstract class AppTypography {
  TextStyle heading(double fontSize, Color color);
  TextStyle body(double fontSize, Color color, {FontWeight fontWeight});
}

@Singleton(as: AppTypography)
class GoogleAppTypography implements AppTypography {
  @override
  TextStyle heading(double fontSize, Color color) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      color: color,
    );
  }

  @override
  TextStyle body(double fontSize, Color color, {FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}