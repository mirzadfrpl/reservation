import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/onboarding/auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/preference/assets.dart';
import 'package:ecommerce/features/preference/colors.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Color(MainColor.primary),
                image: DecorationImage(
                  image: AssetImage(MainAssets.firstOnBoarding),
                  alignment: Alignment(0, 0.5),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              decoration: BoxDecoration(
                color: Color(MainColor.background),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Get The Best Restaurant Deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(MainColor.onBackground),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We will help you to find the best restaurant deals in your area',
                    style: TextStyle(
                      color: Color(MainColor.onBackground).withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Auth()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(MainColor.primary),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(MainColor.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}