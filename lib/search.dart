import 'package:flutter/material.dart';
import 'data/data.dart';
import 'data/ingredient.dart';

class Search extends SearchDelegate<Ingredient> {
  Data data;

  Search(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  String selectedResult;

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: Center(child: Text(selectedResult)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Ingredient> suggestionsList = data.search(query).toList();

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionsList[index].getName()),
          onTap: () async {
            close(context, suggestionsList[index]);
          },
        );
      },
    );
  }
}
