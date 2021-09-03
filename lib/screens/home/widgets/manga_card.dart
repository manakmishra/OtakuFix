import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/screens/manga/manga_info_screen.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({Key key, @required this.manga, this.height, this.onTap})
      : super(key: key);

  final Manga manga;
  final double height;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kNavBarColor,
      onTap: onTap,
      child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              manga.thumbnailUrl,
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}
