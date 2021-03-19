import 'package:flutter/material.dart';
import 'data.dart';

class Search extends SearchDelegate {
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

  List<String> recentList = ['Text 1', 'Text 2'];

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
            print(data.search(suggestionslist[index]));
          },
        );
      },
    );
  }
}
