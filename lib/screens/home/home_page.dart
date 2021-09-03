import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/manga/manga_info_screen.dart';
import 'package:otaku_fix/screens/search/search_delegate.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';
import 'widgets/sliver_heading_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Base _api = MangaTown();
  List<Manga> _mangas = <Manga>[];
  bool _fetching = false;
  Cursor _cursor;

  @override
  Widget build(BuildContext context) {
    if (_cursor == null) {
      _cursor = _api.getLatestMangas();
    }

    Widget child;
    if (_mangas.isEmpty) {
      if (!_fetching) {
        _fetchNextList();
      } else {
        child = Center(
          child: CircularProgressIndicator(),
        );
      }
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
          title: Text('OtakuFix', style: kAppbarTitleStyle),
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
        SliverHeadingText(text: 'Latest Titles:'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 17.5),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MangaCard(
                  manga: _mangas[index],
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        maintainState: false,
                        builder: (_) => MangaInfoScreen(
                          manga: _mangas[index],
                        ),
                      ),
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

  void _fetchNextList() async {
    _fetching = true;
    var mangas = await _cursor.getNext();
    if (!mounted) return;

    setState(() {
      _mangas.addAll(mangas);
      _fetching = false;
    });
  }
}
