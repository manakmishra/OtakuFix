import 'dart:io';
import 'dart:convert';
import 'package:otaku_fix/classes/popular.dart';
import 'package:path_provider/path_provider.dart';

class Favourite extends Popular {
  Favourite({this.img, this.url, this.name, this.lastUpdated})
      : super(img: img, url: url, name: name);
  String img;
  String url;
  String name;
  String lastUpdated;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'name': this.name,
        'url': this.url,
        'image': this.img,
        'last_updated': this.lastUpdated
      };

  Favourite.fromJson(Map json) {
    this.name = json['name'];
    this.url = json['url'];
    this.img = json['image'];
    this.lastUpdated = json['last_updated'];
  }
}

class FavouriteStorage{
  Future get _localPath async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future get _localFile async{
    final path = await _localPath;
    return File('$path/favourites.json');
  }

  Future writeFavourites(List favourites) async{
    try {
      final file = await _localFile;
      String json =  jsonEncode(favourites);

      await file.writeAsString(json, mode: FileMode.write);

      return true;
    } catch (e) {
      print('error $e');
    }

    return false;
  }

  Future readFavourites() async{
    try {
      final file = await _localFile;
      String jsonString = await file.readAsString();
      Iterable jsonMap = jsonDecode(jsonString);
      List favourites = jsonMap.map((parsedJson) => Favourite.fromJson(parsedJson)).toList();

      return favourites;

    } catch (e) {
      print('error');
    }

    return List();
  }
}

class FavMangas{
  FavouriteStorage storage = FavouriteStorage();
  List favourites = [];

  Future readAllFavorites() async {
    favourites = await storage.readFavourites();
    return favourites;
  }

  Future addFavorite(Favourite fav) async {
    List temp = await readAllFavorites();
    if (!temp.any((p) => p.name == fav.name)) {
      temp.add(fav);

      await storage.writeFavourites(favourites);
    }
  }

  bool isFavorite(Favourite fav) {
    return favourites.any((p) => p.name == fav.name);
  }
}