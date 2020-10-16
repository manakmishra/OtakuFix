import 'package:flutter/material.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/screens/splash/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OtakuFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        accentColor: kAccentColor,
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          )
        ),
      ),
      home: Splash(),
    );
  }
}

/*ThemeData(
brightness: Brightness.dark,
primaryColor: kPrimaryColor,
accentColor: kAccentColor,
backgroundColor: kBackgroundColor,
scaffoldBackgroundColor: kBackgroundColor,
visualDensity: VisualDensity.adaptivePlatformDensity,
),*/