import 'package:otaku_fix/classes/chapter.dart';

class Manga {
  String id;
  String name;
  String thumbnailUrl;
  String mangaUrl;
  String lastUpdated;
  String author;
  String status;

  Manga(
      {String id,
      String name,
      String thumbnailUrl,
      String mangaUrl,
      String lastUpdated})
      : this.id = id,
        this.name = name,
        this.thumbnailUrl = thumbnailUrl,
        this.mangaUrl = mangaUrl,
        this.lastUpdated = lastUpdated;

  bool operator ==(o) {
    return o is Manga && this.id == o.id;
  }

  int get hashCode {
    return this.id.hashCode;
  }

  String toString() {
    return '$id, $name, $thumbnailUrl, $lastUpdated';
  }
}
