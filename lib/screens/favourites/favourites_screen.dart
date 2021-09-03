import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/favourite.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/search/search_delegate.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Future<List<Favourite>> _loadFavourites() async {
    FavMangas _favLoader = FavMangas();
    List<Favourite> favourites = List();
    await _favLoader.readAllFavorites().then((value) {
      setState(() {
        favourites = value;
      });
    });

    return favourites;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadFavourites(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: CustomScrollView(
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
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
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
                  padding:
                      const EdgeInsets.only(left: 17.5, right: 17.5, top: 15),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return MangaCard(
                          manga: snapshot.data[index],
                        );
                      },
                      childCount: snapshot.data.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        childAspectRatio: 225 / 320),
                  ),
                ),
              ],
            ));
          } else {
            return InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              child: Container(
                color: kBackgroundColor,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    'Tap anywhere to search for a Manga',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat', color: kAccentColor),
                  ),
                ),
              ),
            );
          }
        });
  }
}
