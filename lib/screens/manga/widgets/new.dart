import 'package:flutter/material.dart';
import 'dart:math';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/classes/chapter.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import '../manga_info_screen.dart';
import 'package:otaku_fix/screens/home/widgets/sliver_heading_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewMangaScreen extends StatefulWidget {
  const NewMangaScreen({
    Key key,
    @required this.manga,
    @required this.widget,
  }) : super(key: key);

  final Manga manga;
  final MangaInfoScreen widget;

  @override
  _NewMangaScreenState createState() => _NewMangaScreenState();
}

class _NewMangaScreenState extends State<NewMangaScreen> {
  List<Chapter> chapters;
  double _angle;
  bool reversed;
  @override
  void initState() {
    chapters = widget.manga.chapters;
    _angle = 0;
    reversed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage img = widget.widget.img == null
        ? CachedNetworkImage(
      imageUrl: widget.manga.img,
    )
        : widget.widget.img;

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
            onPressed: () {}
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
                          style: kBodyTitleStyle,
                        ),
                        Text(
                          widget.manga.status + "\n",
                          textAlign: TextAlign.left,
                          style: kBodyTextStyle
                        ),
                        Text(
                          widget.manga.updated,
                          style: kBodyTextStyle
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverHeadingText(
            text: "Chapters (${chapters.length}): ",
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
                        onPressed: () {/*
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Reader(
                                    url: chapters[index].url,
                                    chapter: chapters[index].name,
                                    chapterList: widget.manga.chapters,
                                    index: reversed
                                        ? widget.manga.chapters
                                        .indexOf(chapters[index])
                                        : index,
                                  )));*/
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