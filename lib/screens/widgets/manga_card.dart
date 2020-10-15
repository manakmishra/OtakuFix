import 'package:flutter/material.dart';
import 'package:otaku_fix/classes/popular.dart';
import 'package:otaku_fix/constants/colours.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({
    Key key,
    @required this.manga,
    this.height

  }) : super(key: key);

  final Popular manga;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kNavBarColor,
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
                manga.img
            ),
          )),
    );
  }
}