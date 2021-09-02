import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangakakalot.dart';
import 'package:otaku_fix/classes/chapter.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/database/db.dart';
import 'package:otaku_fix/screens/home/widgets/sliver_heading_text.dart';
import 'package:otaku_fix/screens/reader/reader.dart';

class MangaInfoScreen extends StatefulWidget {
  MangaInfoScreen({this.manga});
  final Manga manga;
  @override
  _MangaInfoScreenState createState() => _MangaInfoScreenState();
}

class _MangaInfoScreenState extends State<MangaInfoScreen> {
  final Base _api = Mangakakalot();
  List<Chapter> _chapters = <Chapter>[];
  Manga _manga;
  double _angle;
  bool _fetching = false;
  bool _reversed = false;
  Cursor _cursor;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      _manga = widget.manga;
      DB().saveManga(Mangakakalot().name, _manga.mangaUrl, _manga.name,
          _manga.thumbnailUrl);
    });
    _angle = 0;
  }

  void _fetchMangaDetails() async {
    _fetching = true;
    var details = await _api.getMangaDetails(_manga.mangaUrl);

    if (!mounted) return;

    setState(() {
      if (details.chapters.isNotEmpty) {
        _chapters = details.chapters.reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_fetching) {
      _fetchMangaDetails();
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    int length = _chapters.length;

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
                    _chapters = _chapters.reversed.toList();
                    _angle = _angle == 0 ? pi : 0;
                  });
                  _reversed = !_reversed;
                })
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(14),
                      child: Image.network(_manga.thumbnailUrl),
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
                          style: kBodyTitleStyle,
                        ),
                        Text(widget.manga.id + "\n",
                            textAlign: TextAlign.left, style: kBodyTextStyle),
                        Text(widget.manga.lastUpdated, style: kBodyTextStyle)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverHeadingText(
            text: "Chapters ($length): ",
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
                              maintainState: false,
                              builder: (_) => Reader(
                                    url: _chapters[index].url,
                                    chapter: _chapters[index].text,
                                    index: _reversed
                                        ? widget.manga.chapters
                                            .indexOf(_chapters[index])
                                        : index,
                                  )));
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _chapters[index].text,
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
          }, childCount: _chapters.length))
        ],
      ),
    );
  }
}
