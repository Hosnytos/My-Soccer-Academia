import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/team_model.dart';
import 'package:my_soccer_academia/pages/team_details_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

class searchResult extends StatefulWidget {
  String resu = "barcelo";
  searchResult(this.resu);

  @override
  State<searchResult> createState() => _searchResultState(resu: this.resu);
}

class _searchResultState extends State<searchResult>
    with TickerProviderStateMixin {
  _searchResultState({required this.resu});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Data init

  List<teamModel> teamModelList = [];

  String resu = "barcelo";

  late teamModel team;

  @override
  void initState() {
    super.initState();
    getStandingsElems();
  }

  void getStandingsElems() async {
    var allTeams =
        await fetchGetDataList(RequestType.get, '/v3/teams', {"search": resu});

    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 75,
        title: Text('Search',
            style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        //padding: const EdgeInsets.only(top: 15),
        color: Colors.grey[900],
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: teamModelList
                  .map((team) => Container(
                        child: Column(
                          children: [
                            //=========== LEAGUE HEADER SECTION ============
                            ListTile(
                              leading: Container(
                                height: 50,
                                width: 25,
                                child: Image(
                                  image: NetworkImage(team.teamLogo),
                                ),
                              ),
                              title: Text(team.teamName,
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              subtitle: Text(team.leagueCountry,
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey)),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          TeamDetailsPage(team.teamId)));
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      )),
    );
  }
}
