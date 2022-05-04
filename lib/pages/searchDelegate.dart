import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/team_model.dart';
import 'package:my_soccer_academia/pages/standings_details.dart';
import 'package:my_soccer_academia/rest/request.dart';

class searchDelegate extends SearchDelegate {
  List<teamModel> teamModelList = [];

  String resu = "barcelo";

  late teamModel team;

  Future serachdb(searchData) async {
    var allTeams = await fetchGetDataList(
        RequestType.get, '/v3/teams', {"search": searchData});

    var allTeamsBody = allTeams.body;

    //TEAMS DATA
    for (int i = 0; i < allTeamsBody.length; i++) {
      team = teamModel(
        teamId: allTeamsBody[i]['team']['id'],
        teamLogo: allTeamsBody[i]['team']['logo'],
        teamName: allTeamsBody[i]['team']['name'],
        leagueCountry: allTeamsBody[i]['team']['country'],
      );
      // add team standings information from API to list
      teamModelList.add(team);
    }

    return teamModelList;

    /*var url = '$_globalUrl/api/searchdata';
    var param = {'searchby': searchData};
    var result = await http.post(url, body: param);
    return result.body != '' ? json.decode(result.body) : null;*/
  }

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
    List<teamModel> matchQuery = [];
    for (var elem in teamModelList) {
      if (elem.teamName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(elem);
      }
    }

    return Container(
      child: InkWell(child: Text(query)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search a Team'),
    );
  }
}
