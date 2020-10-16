import 'package:flutter/material.dart';
import 'package:otaku_fix/api/main_api.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/search/search_screen.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';
import 'widgets/sliver_heading_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Data appData = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: appData.init(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: false,
                  backgroundColor: kBackgroundColor,
                  elevation: 0,
                  title: Text('OtakuFix', style: kAppbarTitleStyle),
                  actions: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      minWidth: 32,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ],
                ),
                /*SliverHeadingText(text: 'Currently Reading:'),
                SliverToBoxAdapter(
                  child: Container(
                    height: 200.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: appData.populars.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MangaCard(
                                      manga: appData.populars[index],
                                  );
                                },
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),*/
                SliverHeadingText(text: 'Popular Titles:'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.5),
                  sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return MangaCard(
                              manga: appData.populars[index],
                            );
                          },
                        childCount: appData.populars.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        childAspectRatio: 225/320
                      ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}

/*Column(
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
),*/