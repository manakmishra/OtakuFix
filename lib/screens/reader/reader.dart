import 'dart:math';
import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/chapter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:otaku_fix/constants/colours.dart';
import 'package:photo_view/photo_view.dart';

class Reader extends StatefulWidget {
  Reader({this.url, this.chapter, this.chapterList, this.index});
  final String url, chapter;
  final List<Chapter> chapterList;
  final int index;
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  List<String> imageUrls = [];
  Axis _axis = Axis.vertical;
  bool _showAppBar;

  Future<List<String>> getImages() async {
    dom.Document document = await getChapter();
    List<String> imageUrls = [];

    try {
      var e = document.querySelector('#vungdoc');
      var elements = e.querySelectorAll('img');
      elements.forEach((element) {
        imageUrls.add(element.attributes['src']);
      });
    } catch (e) {
      var e = document.querySelector('.container-chapter-reader');
      var elements = e.querySelectorAll('img');
      elements.forEach((element) {
        imageUrls.add(element.attributes['src']);
      });
    }

    return imageUrls;
  }

  Future<dom.Document> getChapter() async {
    http.Response response = await http.get(widget.url);
    dom.Document document = parse(response.body);

    return document;
  }

  @override
  void initState() {
    _showAppBar = true;
    getImages().then((value) {
      setState(() {
        imageUrls = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !_showAppBar
            ? null
            : AppBar(
          title: Text(
            widget.chapter,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: kNavBarColor,
        ),
        body: imageUrls.isNotEmpty
            ? CustomScrollView(
          scrollDirection: _axis,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                              child: PhotoView(
                                onTapDown: (context, details, controllerValue) {
                                  setState(() {
                                    _showAppBar = !_showAppBar;
                                  });
                                },
                                imageProvider: NetworkImage(imageUrls[index]),
                                backgroundDecoration:
                                BoxDecoration(color: Colors.black87),
                              )),
                          Positioned(
                              right: -1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    "${index + 1} / ${imageUrls.length}",
                                    style: TextStyle(color: kAccentColor),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  }, childCount: imageUrls.length),
            )
          ],
        )
            : Center(
          child: Container(),
        ));
  }
}