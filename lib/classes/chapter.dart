import 'package:otaku_fix/classes/popular.dart';

class Chapter extends Popular {
  Chapter({this.url, this.name}) : super(url: url, name: name);
  final String url;
  final String name;
}