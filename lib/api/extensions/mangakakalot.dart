import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:otaku_fix/classes/chapter.dart';
import 'package:otaku_fix/classes/details.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/classes/pages.dart';

//import '../database/db.dart';
import '../api_base.dart';

const maxRetry = 2;

class Mangakakalot extends Base {
  final name = 'mangakakalot';
  final url = 'https://mangakakalot.com/';

  Cursor getLatestMangas() {
    return MangakakalotLatestCursor();
  }

  Cursor getSearchResults(String search) {
    return MangakakalotSearchCursor(search);
  }

  Future<List> getRecentMangas(int n) async {
    if (n < 1) {
      return [];
    }

    //var results = await DBHelper().getAllRecents(name, n);
    var results = [];
    var recents = [];

    for (final row in results) {
      recents.add([
        Manga(
          name: row['name'],
          thumbnailUrl: row['thumbnail'],
          mangaUrl: row['manga'],
        ),
        Chapter.withLastRead(row['chapter'], row['chapter_name'], row['ts']),
      ]);
    }

    return recents;
  }

  Future<Details> getMangaDetails(String mangaUrl) async {
    if (mangaUrl.contains('https://readmanganato.com/')) {
      final response = await _getNeloWebPage(mangaUrl);
      return await _parseNeloDetails(mangaUrl, response.body);
    }

    final response = await http.get(Uri.parse(mangaUrl));
    return await _parseKakalotDetails(mangaUrl, response.body);
  }

  Future<Details> _parseNeloDetails(String mangaUrl, String body) async {
    var document = parse(body);
    var elements = document.getElementsByClassName('chapter-name text-nowrap');

    if (elements.isEmpty) {
      return Details('', <Chapter>[]);
    }

    //var allRead = await DBHelper().getAllRead(name, mangaUrl);
    var allRead;
    var allReadSet = <String>{};
    allReadSet.addAll(allRead);

    var results = <Chapter>[];
    elements.forEach((element) {
      var chapter = Chapter(element.attributes['href'], element.text);
      if (chapter != null) {
        if (allReadSet.contains(chapter.url)) {
          chapter.isRead = true;
        }
        results.add(chapter);
      }
    });

    return Details('', results);
  }

  Future<Details> _parseKakalotDetails(String mangaUrl, String body) async {
    var document = parse(body);
    var elements = document.getElementsByClassName('chapter-list');

    if (elements.isEmpty) {
      return Details('', <Chapter>[]);
    }

    //var allRead = await DBHelper().getAllRead(name, mangaUrl);
    var allRead;
    var allReadSet = <String>{};
    allReadSet.addAll(allRead);

    var results = <Chapter>[];
    elements[0].children.forEach((element) {
      var chapter = _parseLink(element);
      if (chapter != null) {
        if (allReadSet.contains(chapter.url)) {
          chapter.isRead = true;
        }
        results.add(chapter);
      }
    });

    return Details('', results);
  }

  Chapter _parseLink(dom.Element element) {
    var a = element.getElementsByTagName('a');
    if (a.isEmpty) {
      return null;
    }

    if (!a[0].attributes.containsKey('href')) {
      return null;
    }

    return Chapter(a[0].attributes['href'], a[0].text);
  }

  Future<Pages> getChapterPages(chptUrl) async {
    if (chptUrl.startsWith('https://readmanganato.com/')) {
      final response = await _getNeloWebPage(chptUrl);
      var pages = _getNeloPages(response.body);
      var prevNextChapter = _getPrevNextNeloChapterUrls(response.body, chptUrl);
      var title = _getNeloChapterTitle(response.body, chptUrl);
      return Pages(pages, prevNextChapter[0], prevNextChapter[1], title);
    }

    var url = Uri.parse(chptUrl);
    final response = await http.get(url);
    var pages = _getKakalotPages(response.body);
    var prevNextChapter =
        _getPrevNextKakalotChapterUrls(response.body, chptUrl);
    var title = _getKakalotChapterTitle(response.body, chptUrl);

    return Pages(pages, prevNextChapter[0], prevNextChapter[1], title);
  }

  List<String> _getNeloPages(String body) {
    var document = parse(body);

    var pages = document.getElementsByClassName('container-chapter-reader');

    var imgUrls = <String>[];
    pages[0].children.forEach((img) {
      var imgSrc = img.attributes['src'];
      if (imgSrc == null ||
          !imgSrc.startsWith('https://') ||
          !imgSrc.endsWith('.jpg')) {
        return;
      }
      imgUrls.add(imgSrc);
    });

    return imgUrls;
  }

  String _getNeloChapterTitle(String body, String chaptUrl) {
    var document = parse(body);

    var crumbs = document.getElementsByClassName('panel-breadcrumb').first;

    var anchors = crumbs.getElementsByTagName('a');
    for (final anchor in anchors) {
      if (anchor.attributes['href'] == chaptUrl) {
        return anchor.text;
      }
    }

    return '';
  }

  List<String> _getKakalotPages(String body) {
    var document = parse(body);

    var pages =
        document.getElementsByClassName('container-chapter-reader').first;

    var imgUrls = <String>[];
    pages.children.forEach((img) {
      var imgSrc = img.attributes['src'];
      if (imgSrc == null ||
          !imgSrc.startsWith('https://') ||
          !imgSrc.endsWith('.jpg')) {
        return;
      }
      imgUrls.add(imgSrc);
    });

    return imgUrls;
  }

  List<String> _getPrevNextNeloChapterUrls(String body, chptUrl) {
    var document = parse(body);
    var prevE =
        document.getElementsByClassName('navi-change-chapter-btn-prev a-h');
    var nextE =
        document.getElementsByClassName('navi-change-chapter-btn-next a-h');

    // for when website mistakenly links next/prev chapter as current chapter
    var prevChptUrl = prevE.isEmpty || prevE[0].attributes['href'] == chptUrl
        ? ''
        : prevE[0].attributes['href'];
    var nextChptUrl = nextE.isEmpty || nextE[0].attributes['href'] == chptUrl
        ? ''
        : nextE[0].attributes['href'];

    return [
      prevChptUrl,
      nextChptUrl,
    ];
  }

  List<String> _getPrevNextKakalotChapterUrls(String body, chptUrl) {
    var document = parse(body);
    var navigation = document.getElementsByClassName('btn-navigation-chap');
    // kakalot messes up the class names
    var prevE = navigation[0].getElementsByClassName('next');
    var nextE = navigation[0].getElementsByClassName('back');

    return [
      prevE.isEmpty ? '' : prevE[0].attributes['href'],
      nextE.isEmpty ? '' : nextE[0].attributes['href'],
    ];
  }

  String _getKakalotChapterTitle(String body, String chaptUrl) {
    var document = parse(body);

    var crumbs = document
        .getElementsByClassName('breadcrumb breadcrumbs bred_doc')
        .first;

    var anchors = crumbs.getElementsByTagName('a');
    for (final anchor in anchors) {
      if (anchor.attributes['href'] == chaptUrl) {
        var span = anchor.getElementsByTagName('span').first;
        return span.text;
      }
    }

    return '';
  }
}

class MangakakalotLatestCursor extends Cursor {
  num _index;

  MangakakalotLatestCursor() {
    _index = 1;
  }

  Future<List<Manga>> getNext() async {
    var url = Uri.parse(
        'https://mangakakalot.com/manga_list?type=latest&category=all&state=all&page=$_index');
    final response = await http.get(url);
    var mangas = _getMangas(response.body);

    _index += 1;

    return mangas;
  }

  List<Manga> _getMangas(String body) {
    var document = parse(body);
    var elements = document.getElementsByClassName('list-truyen-item-wrap');

    if (elements.isEmpty) {
      return <Manga>[];
    }

    var results = <Manga>[];
    elements.forEach((element) {
      var manga = _parseManga(element);
      if (manga != null) {
        results.add(manga);
      }
    });

    return results;
  }

  Manga _parseManga(dom.Element element) {
    var manga = Manga();
    var elements = element.children;
    if (elements.isEmpty) {
      return null;
    }
    var eCover = elements[0];

    if (!eCover.attributes.containsKey('href') ||
        !eCover.attributes.containsKey('title')) {
      return null;
    }

    manga.mangaUrl = eCover.attributes['href'];

    var splitHref = manga.mangaUrl.split('/manga/');

    manga.id = splitHref.last;
    manga.name = eCover.attributes['title'];

    elements = eCover.children;
    if (elements.isEmpty) {
      return null;
    }
    var eImg = elements[0];
    manga.thumbnailUrl = eImg.attributes['src'];
    manga.lastUpdated = '';

    return manga;
  }
}

class MangakakalotSearchCursor extends MangakakalotLatestCursor {
  String searchTerm;

  MangakakalotSearchCursor(String searchTerm) {
    this.searchTerm = searchTerm.replaceAll(' ', '_');
  }

  Future<List<Manga>> getNext() async {
    var url = 'https://mangakakalot.com/search/story/$searchTerm?page=$_index';
    url = Uri.encodeFull(url);
    final response = await http.get(Uri.parse(url));
    var mangas = _getMangas(response.body);

    _index += 1;

    return mangas;
  }

  List<Manga> _getMangas(String body) {
    var document = parse(body);
    var elements = document.getElementsByClassName('story_item');

    if (elements.isEmpty) {
      return <Manga>[];
    }

    var results = <Manga>[];
    elements.forEach((element) {
      var manga = _parseManga(element);
      if (manga != null) {
        results.add(manga);
      }
    });

    return results;
  }

  Manga _parseManga(dom.Element element) {
    var manga = Manga();
    var elements = element.children;
    if (elements.isEmpty) {
      return null;
    }
    var eMangaUrl = elements[0];

    if (!eMangaUrl.attributes.containsKey('href')) {
      return null;
    }

    manga.mangaUrl = eMangaUrl.attributes['href'];

    var splitHref = manga.mangaUrl.split('/manga/');

    manga.id = splitHref.last;

    var eCover = eMangaUrl.children[0];
    manga.thumbnailUrl = eCover.attributes['src'];

    var eName = element.getElementsByClassName('story_name');
    manga.name = eName[0].children[0].text;
    manga.lastUpdated = '';

    return manga;
  }
}

Future<Response> _getNeloWebPage(String url) async {
  var response = await http.get(Uri.parse(url));
  var retryCount = 0;

  while (_isPHPError(response.body) && retryCount < maxRetry) {
    debugPrint(response.body, wrapWidth: 1024);
    response = await http.get(Uri.parse(url));
    retryCount += 1;
  }

  return response;
}

bool _isPHPError(String body) {
  var exp = new RegExp(r'<h4>A PHP Error was encountered</h4>');

  return !(exp.firstMatch(body) == null);
}
