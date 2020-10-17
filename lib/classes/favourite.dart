import 'dart:io';
import 'dart:convert';
import 'package:otaku_fix/classes/popular.dart';
import 'package:otaku_fix/screens/favourites/favourites_screen.dart';
import 'package:path_provider/path_provider.dart';

class Favourite extends Popular {
  Favourite({this.img, this.url, this.name})
      : super(img: img, url: url, name: name);
  String img;
  String url;
  String name;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'name': this.name,
        'url': this.url,
        'image': this.img,
      };

  Favourite.fromJson(Map json) {
    this.name = json['name'];
    this.url = json['url'];
    this.img = json['image'];
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
      print(jsonString);
      return favourites;

    } catch (e) {
      print('error');
    }
    return List();
  }
}

class FavMangas{
  FavMangas({this.screen});
  FavouritesScreen screen;

  FavouriteStorage storage = FavouriteStorage();
  List favourites = [];

  Future readAllFavorites() async {
    favourites = await storage.readFavourites();
    return favourites;
  }

  Future addFavorite(Favourite fav) async {
    List favourites = await readAllFavorites();
    if (!favourites.any((p) => p.name == fav.name)) {
      favourites.add(fav);
      await storage.writeFavourites(favourites);
    }
  }

  bool isFavorite(Favourite fav) {
    return favourites.any((p) => p.name == fav.name);
  }
}