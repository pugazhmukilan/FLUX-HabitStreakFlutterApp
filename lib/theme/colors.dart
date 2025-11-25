import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors{
  static const Color white = Color(0xFFFFFFFE);
  static const Color blackdark = Color(0xFF232323);
  static const Color greydark = Color(0xFF303030);
  static const Color greylight = Color(0xFFF0F0F0);

  static const Color greenprimary = Color(0xFF50A65C);
  static const Color green1 = Color(0xFF4B9B56);
  static const Color green2 = Color(0xFF6BD278);
  static const Color green3 = Color(0xFFB6E5BC);
  


}


class AppTheme{
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.greenprimary,
    colorScheme: const ColorScheme.light(
        primary: AppColors.white,          // M3 primary color
        onPrimary: AppColors.white,        // Text on primary
        secondary: AppColors.blackdark,
        onSecondary: AppColors.greydark,

        surface: Colors.white,
        onSurface: AppColors.blackdark,        // MOST IMPORTANT → body text, card text

        background: Colors.white,
        onBackground: Colors.black,

        error: Colors.red,
        onError: Colors.white,
  ),


  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blackdark,
        foregroundColor: AppColors.white

      )
    ),
    
   
    
    
    
  );


  static final ThemeData darkTheme  = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.blackdark,
    primaryColor: AppColors.greenprimary,
    colorScheme: const ColorScheme.dark(
      primary:AppColors.blackdark,
      onPrimary: AppColors.greydark,
      secondary: AppColors.greenprimary,
      onSecondary: AppColors.green1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greenprimary,
        foregroundColor: AppColors.white

      )
    ),
  );
}