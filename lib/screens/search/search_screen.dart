import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/screens/search/widgets/search_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Widget> widgets = [];
  final Base _api = MangaTown();
  List<Manga> _mangas = <Manga>[];
  bool _fetching = false;
  Cursor _cursor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
