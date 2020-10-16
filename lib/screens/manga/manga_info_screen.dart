import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'widgets/old.dart';
import 'widgets/new.dart';

class MangaInfoScreen extends StatefulWidget {
  MangaInfoScreen({this.url, this.img});
  final String url;
  final CachedNetworkImage img;
  @override
  _MangaInfoScreenState createState() => _MangaInfoScreenState();
}

class _MangaInfoScreenState extends State<MangaInfoScreen> {
  Manga manga;
  @override
  void initState() {
    getManga(widget.url).then((value) {
      setState(() {
        manga = Manga(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return manga != null
        ? manga.old
        ? OldMangaScreen(manga: manga, widget: widget)
        : NewMangaScreen(manga: manga, widget: widget)
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}