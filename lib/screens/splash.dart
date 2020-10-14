import 'package:flutter/material.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/home_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1;

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*Image.asset(
                  //add logo if time permits,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),*/
                AnimatedOpacity(
                    opacity: _opacity,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Text(
                      'OtakuFix',
                      style: kSplashTitleStyle,
                    )
                )
              ],
            )),
      ),
    );
  }
}