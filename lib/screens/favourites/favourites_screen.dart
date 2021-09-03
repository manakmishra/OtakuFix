import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/home/widgets/sliver_heading_text.dart';
import 'package:otaku_fix/screens/manga/manga_info_screen.dart';
import 'package:otaku_fix/screens/search/search_delegate.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final MangaTown _api = MangaTown();
  List<Manga> _mangas = <Manga>[];
  bool _fetching = false;
  Cursor _cursor;

  @override
  Widget build(BuildContext context) {
    if (_cursor == null) {
      _cursor = _api.getFavorites();
    }

    _fetchList();

    Widget child;
    if (_mangas.isEmpty) {
      child = InkWell(
        onTap: () => showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        ),
        child: Container(
          color: kBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              'Tap anywhere to search for a Manga',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat', color: kAccentColor),
            ),
          ),
        ),
      );
    } else {
      child = _buildMangaList();
    }

    return Container(
      color: kBackgroundColor,
      child: child,
    );
  }

  Widget _buildMangaList() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: false,
          snap: false,
          backgroundColor: kBackgroundColor,
          elevation: 0,
          title: Text('Favorites', style: kAppbarTitleStyle),
          actions: <Widget>[
            TextButton(
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
              const EdgeInsets.symmetric(horizontal: 17.5).copyWith(top: 18),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MangaCard(
                  manga: _mangas[index],
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => MangaInfoScreen(
                                manga: _mangas[index],
                              )),
                    );
                  },
                );
              },
              childCount: _mangas.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 225 / 320),
          ),
        ),
      ],
    );
  }

  void _fetchList() async {
    _fetching = true;
    var mangas = await _cursor.getNext();
    if (!mounted) return;

    setState(() {
      _mangas = mangas;
      _fetching = false;
    });
  }
}
