import 'package:flutter/material.dart';
import 'package:otaku_fix/api/api_base.dart';
import 'package:otaku_fix/api/extensions/mangatown.dart';
import 'package:otaku_fix/classes/manga.dart';
import 'package:otaku_fix/constants/colours.dart';
import 'package:otaku_fix/constants/text_styles.dart';
import 'package:otaku_fix/screens/home/widgets/manga_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  final Base _api = MangaTown();
  List<Manga> _mangas = <Manga>[];
  bool _showClearButton = false;
  bool _notFetching = false;
  Cursor _cursor;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        backgroundColor: kBackgroundColor,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
        elevation: 0,
        titleTextStyle: kBodyTextStyle,
        toolbarTextStyle: kBodyTextStyle,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: kBodyTextStyle.copyWith(fontSize: 20),
            labelStyle: kBodyTextStyle.copyWith(fontSize: 20),
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    _cursor = _api.getSearchResults(query);
    /*_mangas.clear();
    var mangas = _cursor.getNext();

    _mangas.addAll(mangas);
    if ((await mangas).isNotEmpty) {
      _notFetching = true;
    }*/

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder(
          stream: _cursor.getNext().asStream(),
          initialData: <Manga>[],
          builder: (context, AsyncSnapshot<List<Manga>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "No Results Found.",
                ),
              );
            } else {
              var results = snapshot.data;
              /*return ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return MangaCard(
                    manga: result,
                  );
                },
              );*/
              return GridView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  childAspectRatio: 225 / 320,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return MangaCard(
                    manga: results[index],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
