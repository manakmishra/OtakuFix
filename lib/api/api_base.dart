import 'package:otaku_fix/classes/details.dart';
import 'package:otaku_fix/classes/pages.dart';
import 'package:otaku_fix/classes/manga.dart';

abstract class Base {
  Future<Details> getMangaDetails(String id);
  Future<Pages> getChapterPages(String chapterUrl);
  Future<List> getRecentMangas(int n);
  Cursor getLatestMangas();
  Cursor getSearchResults(String search);
}

abstract class Cursor {
  Future<List<Manga>> getNext();
}
