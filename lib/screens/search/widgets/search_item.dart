import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:otaku_fix/api/search_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:otaku_fix/screens/manga/manga_info_screen.dart';

class SearchItem extends StatefulWidget {
  SearchItem({this.result});

  final SearchResults result;
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

  String name;

  @override
  void initState() {
    name = parse("<h1>${widget.result.name}</h1>").querySelector('h1').text;
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
                    img: CachedNetworkImage(imageUrl: widget.result.image),
                    url: widget.result.idEncode)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height*0.2,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    child: CachedNetworkImage(imageUrl: widget.result.image),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Name: $name",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Latest: ${widget.result.lastChapter}",
                        textAlign: TextAlign.left,
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
