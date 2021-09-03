import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';

import 'package:otaku_fix/database/db.dart';

class ReaderState extends State<Reader> {
  final MangaTown _api = MangaTown();
  final List<String> _images = <String>[];
  final Set<String> _chapters = <String>{};
  String _manga;

  bool _isFetching = false;
  String _prevChapter = '';
  String _currChapter = '';
  String _nextChapter = '';

  @override
  Widget build(BuildContext context) {
    _manga = widget.mangaUrl;

    var chapterUrl = widget.chapterUrl;
    if (!_chapters.contains(chapterUrl)) {
      _nextChapter = chapterUrl;
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: false,
          snap: false,
          backgroundColor: kBackgroundColor,
          elevation: 0,
          title: Text(
            'Chapter YYY',
            textAlign: TextAlign.left,
            style: kBodyTitleStyle,
          ),
        ),
        SliverFillRemaining(
          child: _buildPages(this._images, padding: 0),
        ),
      ],
    );
  }

  Widget _buildPages(List<String> images, {double padding = 10}) {
    return ListView.builder(
      itemBuilder: (BuildContext _context, int i) {
        if (i >= _images.length) {
          if (_nextChapter != '' && !_isFetching) {
            _fetchPages(_nextChapter);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return null;
        }

        return _buildPage(images[i], _manga, padding);
      },
      shrinkWrap: true,
    );
  }

  void _fetchPages(String url) async {
    if (_chapters.contains(url) || url == null || url == '') {
      return;
    }

    _isFetching = true;
    var chpt = await _api.getChapterPages(url);

    if (_manga != '') DB().saveRead(_api.name, _manga, url, chpt.title);

    if (!mounted) return;
    setState(() {
      _chapters.add(url);
      _prevChapter = chpt.prevChapterUrl;
      _currChapter = url;
      _nextChapter = chpt.nextChapterUrl;
      _isFetching = false;

      if (_currChapter == chpt.nextChapterUrl) {
        // append at the back
      } else {
        _images.addAll(chpt.pages);
      }
    });
  }
}

class Reader extends StatefulWidget {
  Reader({this.mangaUrl, this.chapterUrl});
  final String mangaUrl, chapterUrl;

  @override
  ReaderState createState() => ReaderState();
}

class MangaPageState extends State<MangaPage> {
  int reloadCount = 0;
  int oldReloadCount = 0;

  @override
  Widget build(BuildContext context) {
    var reload = GestureDetector(
        child: SizedBox(
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            width: 50),
        onTap: () {
          setState(() {
            reloadCount += 1;
          });
        });

    var cacheKey = reloadCount.toString() + widget.pageUrl;

    Widget child;

    if (reloadCount == oldReloadCount) {
      child = CachedNetworkImage(
          httpHeaders: {'referrer': widget.mangaUrl},
          imageUrl: widget.pageUrl,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => reload);
    } else {
      child = Center(
        child: CircularProgressIndicator(),
      );
      _reloadImage(widget.pageUrl, cacheKey);
    }

    return child;
  }

  void _reloadImage(String url, String cacheKey) async {
    await CachedNetworkImage.evictFromCache(url);
    setState(() {
      oldReloadCount = reloadCount;
    });
  }
}

class MangaPage extends StatefulWidget {
  final String pageUrl;
  final String mangaUrl;

  MangaPage({@required this.pageUrl, this.mangaUrl});

  @override
  MangaPageState createState() => MangaPageState();
}

Widget _buildPage(String pageUrl, String mangaUrl, double btm) {
  return Container(
      padding: EdgeInsets.only(bottom: btm),
      child: MangaPage(pageUrl: pageUrl, mangaUrl: mangaUrl));
}
