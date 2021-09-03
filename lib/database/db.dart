import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/database/migrations/002_add_source_to_read.dart';
import 'package:otaku_fix/database/migrations/003_add_manga_add_timestamp.dart';
import 'package:otaku_fix/database/migrations/004_add_manga_thumbnail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DB {
  final String _path = 'otakufix.db';
  static Database _db;
  var _upgrades = [
    upgradeTo002,
    upgradeTo003,
    upgradeTo004,
  ];

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _path);

    var openDb = openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: (Database db, int oldVersion, int newVersion) async => {},
    );

    return openDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE read(
        id INTEGER PRIMARY KEY,
        manga TEXT,
        chapter TEXT,
        UNIQUE(manga, chapter)
      )
    """);

    for (final upgrade in _upgrades.sublist(0, version - 1)) {
      await upgrade(db);
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == newVersion) return;

    for (final upgrade in _upgrades.sublist(oldVersion - 1, newVersion - 1)) {
      await upgrade(db);
    }
  }

  Future<List<String>> getAllRead(String source, String manga) async {
    var dbClient = await db;

    var list = await dbClient.query('read',
        columns: ['chapter'],
        where: 'manga = ? AND source = ?',
        whereArgs: [manga, source]);

    var readList = <String>[];
    for (int i = 0; i < list.length; i++) {
      readList.add(list[i]['chapter']);
    }

    return readList;
  }

  Future<List<Map<String, dynamic>>> getAllRecents(String source, int n) async {
    if (n < 1) {
      return [];
    }

    var dbClient = await db;

    var list = await dbClient.rawQuery('''
      SELECT manga.*, read.ts, read.chapter_name, read.chapter FROM read
      INNER JOIN manga ON manga.manga = read.manga
      WHERE read.id in (
        SELECT MAX(r1.id) as rid FROM read r1
        WHERE r1.source = ?
        GROUP BY r1.manga
        ORDER BY MAX(r1.ts) DESC
        LIMIT ?
      )
      AND manga.thumbnail IS NOT NULL
      AND read.chapter_name IS NOT NULL
      ORDER BY ts DESC
      ''', [source, n]);

    return list;
  }

  Future<List<Map<String, dynamic>>> getAllFavorites(String source) async {
    var dbClient = await db;

    var list = await dbClient.query('favorite', distinct: true);

    return list;
  }

  Future<bool> checkFavorite(String source, String manga) async {
    var dbClient = await db;
    var check = await dbClient.rawQuery('''
      SELECT 1 FROM favorite 
      WHERE source = ? AND manga = ?
     ''', [source, manga]);

    return check.isNotEmpty;
  }

  Future<int> saveRead(
      String source, String manga, String chapter, String chapterName) async {
    var dbClient = await db;

    final ts = DateTime.now().millisecondsSinceEpoch;
    var recordId = await dbClient.insert(
      'read',
      {
        'source': source,
        'manga': manga,
        'chapter': chapter,
        'ts': ts,
        'chapter_name': chapterName
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recordId;
  }

  Future<int> saveFavorite(String source, Manga manga) async {
    var dbClient = await db;

    final ts = DateTime.now().millisecondsSinceEpoch;
    var recordId = await dbClient.insert(
      'favorite',
      {
        'source': source,
        'manga': manga.mangaUrl,
        'name': manga.name,
        'thumbnail': manga.thumbnailUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recordId;
  }

  Future<int> removeFavorite(String source, Manga manga) async {
    var dbClient = await db;
    var recordId = await dbClient.delete(
      'favorite',
      where: 'source = ? AND manga = ?',
      whereArgs: [source, manga.mangaUrl],
    );
    return recordId;
  }

  Future<int> saveManga(
      String source, String manga, String name, String thumbnail) async {
    var dbClient = await db;

    var recordId = await dbClient.insert(
      'manga',
      {'source': source, 'manga': manga, 'name': name, 'thumbnail': thumbnail},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return recordId;
  }
}
