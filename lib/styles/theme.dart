import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1976D2);
const Color secondaryColor = Color(0xFF00BFA5);

const Color lightBackgroundColor = Color(0xFFF5F5F5);
const Color lightSurfaceColor = Colors.white;

const Color darkBackgroundColor = Color(0xFF121212);
const Color darkSurfaceColor = Color(0xFF1E1E1E);

const Color lightTextColor = Colors.black87;
const Color darkTextColor = Colors.white;

final TextTheme myTextTheme = TextTheme(
  headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
).apply(fontFamily: 'Josefin Sans');

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: lightBackgroundColor,
  fontFamily: 'Josefin Sans',
  textTheme: myTextTheme.apply(
    bodyColor: lightTextColor,
    displayColor: lightTextColor,
  ),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: lightSurfaceColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: lightTextColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  fontFamily: 'Josefin Sans',
  textTheme: myTextTheme.apply(
    bodyColor: darkTextColor,
    displayColor: darkTextColor,
  ),
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: darkSurfaceColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: darkTextColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurfaceColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: darkSurfaceColor,
  ),
);
