import 'package:flutter/material.dart';
import 'data.dart';
import 'ingredient.dart';

class Search extends SearchDelegate {
  Function function;
  Data data;

  Search(this.data, this.function);

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

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionslist = [];
    query.isEmpty
        ? suggestionslist = recentList
        : suggestionslist.addAll(data.searchString(query));
    return ListView.builder(
      itemCount: suggestionslist.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionslist[index]),
          hoverColor: Colors.green,
          onTap: () {
            Ingredient ingredient = data.ingredients.firstWhere(
                (ingredient) => ingredient.getName() == suggestionslist[index]);
            function.call(ingredient);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
