import 'package:flutter/material.dart';
import 'package:otaku_fix/api/main_api.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Data appData = Data();

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
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Currently Reading:',
                  style: kBodyTitleStyle,
                ),
                SizedBox(height: 20.0),
                Container( //add horizontal list view here
                  width: double.infinity,
                  height: 160.0,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 30.0),
                Text(
                  'Popular Titles:',
                  style: kBodyTitleStyle,
                ),
                SizedBox(height: 20.0),
                Container( // add vertical list view/grid view
                  color: Colors.blueAccent,
                  width: double.infinity,
                  height: 350.0,
                ),
              ],
            ),
        ),
      ),
    );
  }
}
