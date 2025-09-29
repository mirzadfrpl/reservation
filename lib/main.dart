import 'package:ecommerce/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/service/api_service.dart';
import 'package:ecommerce/providers/restaurant_provider.dart';
import 'package:ecommerce/providers/theme_provider.dart';
import 'package:ecommerce/providers/daily_reminder_provider.dart';
import 'package:ecommerce/styles/theme.dart';
import 'package:ecommerce/providers/home_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/providers/favourite_provider.dart';
import 'package:ecommerce/db/database_helper.dart';
import 'package:ecommerce/utils/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  notificationHelper.initNotifications();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DailyReminderProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Restaurant App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
