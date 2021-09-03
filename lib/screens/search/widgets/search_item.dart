import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/manga/manga_info_screen.dart';

class SearchItem extends StatefulWidget {
  SearchItem({this.result});

  final Manga result;
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  String name;

  @override
  void initState() {
    name = widget.result.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MangaInfoScreen(
              manga: widget.result,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: CachedNetworkImage(
                        imageUrl: widget.result.thumbnailUrl,
                        errorWidget: (ctx, msg, _) => Container(
                          child: Center(
                            child: Text(
                              'Cannot load thumbnail: ${_.statusCode}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "$name",
                        style: kBodyTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Last Updated: \n${widget.result.lastUpdated}",
                        textAlign: TextAlign.center,
                        style: kBodyTextStyle,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
