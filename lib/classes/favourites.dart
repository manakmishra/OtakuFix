import 'package:otaku_fix/classes/popular.dart';

class Favourites extends Popular {
  Favourites({this.img, this.url, this.name})
      : super(img: img, url: url, name: name);
  final String img;
  final String url;
  final String name;
}