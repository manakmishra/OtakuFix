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
}
