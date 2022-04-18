import 'package:flutter/material.dart';

class searchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Liga',
    'Ligue 1',
    'Bundesliga',
    'Premier League',
    'CAN'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var elem in searchTerms) {
      if (elem.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(elem);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var resu = matchQuery[index];
        return ListTile(
          title: Text(resu),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var elem in searchTerms) {
      if (elem.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(elem);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var resu = matchQuery[index];
        return ListTile(
          title: Text(resu),
        );
      },
    );
  }
}
