import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:floating_search_bar/ui/sliver_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: _controller,
      leading: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back),
      ),
      trailing: FlatButton(
        onPressed: () {
          setState(() {
            widgets = [
              Center(
                child: CircularProgressIndicator(),
              )
            ];
          });

          //add search results from api
        },
        child: Icon(Icons.search),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
