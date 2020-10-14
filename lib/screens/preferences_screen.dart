import 'package:flutter/material.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';

class PreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text('OtakuFix', style: kAppbarTitleStyle),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0),
            minWidth: 32,
            onPressed: () {},
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 28.0,
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
