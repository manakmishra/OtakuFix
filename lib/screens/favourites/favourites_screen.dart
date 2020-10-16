import 'package:flutter/material.dart';
import 'package:otaku_fix/api/main_api.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/search/search_screen.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class FavouritesScreen extends StatelessWidget {
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
