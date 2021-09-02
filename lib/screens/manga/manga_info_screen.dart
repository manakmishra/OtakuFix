import 'dart:math';

import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
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
  final Base _api = MangaTown();
  List<Chapter> _chapters = <Chapter>[];
  Manga _manga;
  double _angle;
  bool _fetching = false;
  bool _reversed = false;

  @override
  void initState() {
    super.initState();
    _manga = widget.manga;
    DB().saveManga(
        MangaTown().name, _manga.mangaUrl, _manga.name, _manga.thumbnailUrl);
    _angle = pi;
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
        title: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            widget.manga.name,
            textAlign: TextAlign.left,
            style: kBodyTitleStyle,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(14),
                        child: Image.network(_manga.thumbnailUrl),
                        height: MediaQuery.of(context).size.height * 0.3,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            _manga.name,
                            textAlign: TextAlign.left,
                            style: kBodyTitleStyle,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Author: ',
                                      style: kBodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _manga.author,
                                      style: kBodyTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Status: ',
                                      style: kBodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _manga.status,
                                      style: kBodyTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Last Updated: ',
                                      style: kBodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _manga.lastUpdated,
                                      style: kBodyTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 14.0),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () => print("favourited"),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.favorite_border_rounded),
                                  Text(
                                    '  Favorite this title!',
                                    style: kBodyTextStyle,
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>((_) {
                                  return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20));
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (_) => kNavBarColor),
                                elevation:
                                    MaterialStateProperty.resolveWith<double>(
                                        (_) => 3.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 18.0, top: 15.0),
                  child: Text(
                    "Chapters ($length): ",
                    style: kBodyTitleStyle,
                  ),
                ),
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
                  },
                ),
              ],
            ),
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
                      /*Navigator.push(
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
                                  )));*/
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
