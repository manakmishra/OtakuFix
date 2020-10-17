import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/favourite.dart';
import 'dart:math';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/classes/chapter.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/home/widgets/sliver_heading_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../manga_info_screen.dart';
import 'package:otaku_fix/screens/reader/reader.dart';

class OldMangaScreen extends StatefulWidget {
  OldMangaScreen({
    Key key,
    @required this.manga,
    @required this.widget,
  }) : super(key: key);
  final Manga manga;
  final MangaInfoScreen widget;
  @override
  _OldMangaScreenState createState() => _OldMangaScreenState();
}

class _OldMangaScreenState extends State<OldMangaScreen> {
  CachedNetworkImage img;
  List<Chapter> chapters;
  double _angle;
  @override
  void initState() {
    chapters = widget.manga.chapters;
    _angle = 0;
    img = widget.widget.img == null
        ? CachedNetworkImage(imageUrl: widget.manga.img)
        : widget.widget.img;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Row(
          children: <Widget>[
            IconButton(
                icon: Transform.rotate(
                  angle: _angle,
                  child: Icon(Icons.filter_list),
                ),
                onPressed: () {
                  setState(() {
                    chapters = chapters.reversed.toList();
                    _angle = _angle == 0 ? pi : 0;
                  });
                })
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () async {
                FavMangas fav = FavMangas();
                fav.addFavorite(new Favourite(
                  img: widget.manga.img,
                  name: widget.manga.name,
                  url: widget.manga.url,
                ));
              }
              )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(14.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: img,
                      height: MediaQuery.of(context).size.height * 0.3,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.manga.name,
                          textAlign: TextAlign.left,
                          style: kBodyTitleStyle
                        ),
                        Text(
                          widget.manga.status + "\n",
                          textAlign: TextAlign.left,
                          style: kBodyTextStyle
                        ),
                        Text(
                          widget.manga.updated,
                          style: kBodyTextStyle,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverHeadingText(
            text: "Chapters: ",
          ),
          SliverList(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: FlatButton(
                        splashColor: kNavBarColor,
                        color: kBackgroundColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Reader(
                                    url: chapters[index].url,
                                    chapter: chapters[index].name,
                                  )));
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            chapters[index].name,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: kAccentColor,
                    )
                  ],
                );
              }, childCount: chapters.length))
        ],
      ),
    );
  }
}