import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/favourite.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/search/search_screen.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  FavMangas _favLoader = FavMangas();

  List<Favourite> favourites = [];

  loadFavourites() async {
    favourites = await _favLoader.readAllFavorites();
  }

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFavourites(),
        builder: (context, snapshot) {
          if (favourites.isNotEmpty) {
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) =>
                                    SearchScreen()));
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
                              manga: favourites[index],
                            );
                          },
                          childCount: favourites.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1,
                            childAspectRatio: 225 / 320
                        ),
                      ),
                    ),
                  ],
                )
            );
          } else {
            return Container(
              color: kBackgroundColor,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()));
                  },
                  child: Text(
                    'Tap anywhere to search for a Manga',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: kAccentColor
                    ),
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}

