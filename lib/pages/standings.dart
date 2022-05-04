import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/team_standings_model.dart';
import 'package:my_soccer_academia/pages/standings_details.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:flutter_svg/flutter_svg.dart';

class standings extends StatefulWidget {
  @override
  State<standings> createState() => _standingsState();
}

class _standingsState extends State<standings> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Data init
  List<int> listFavLeague = [
    39,
    61,
    78,
    135,
    140
  ]; // PREMIER LEAGUE - LIGUE 1 - BUNDESLIGA - SERIE A - LA LIGA
  List<teamStandingsModel> teamStandingsModelList = [];
  List<teamStandingsModel> teamStandingsModelList2 = [];

  int leagueId = 61;
  String leagueName = "";
  String leagueLogo = "";
  int leagueSeason = 0;
  int fixtureId = 721066;

  var standingsMap = [];

  late teamStandingsModel team;

  //List<fixturesDetails> fixturesDetailsModelList = [];
  //late fixturesDetails fixtures;

  @override
  void initState() {
    super.initState();
    getStandingsElems();
  }

  void getStandingsElems() async {
    for (int k = 0; k < listFavLeague.length; k++) {
      List<teamStandingsModel> teamStandingsModelList = [];
      var leagueID = listFavLeague[k];

      var allTeams = await fetchGetDataList(RequestType.get, '/v3/standings',
          {"league": "$leagueID", "season": "2021"});

      setState(() {
        var allTeamsBody = allTeams.body;

        //var verifLeagueLength = allTeamsBody[0]['league']['standings'][0];
        var verifLeagueLength = 5;

        //TEAMS DATA
        for (int j = 0; j < verifLeagueLength; j++) {
          team = teamStandingsModel(
              leagueID: allTeamsBody[0]['league']['id'],
              leagueName: allTeamsBody[0]['league']['name'],
              leagueLogo: allTeamsBody[0]['league']['logo'],
              leagueSeason: allTeamsBody[0]['league']['season'],
              leagueCountry: allTeamsBody[0]['league']['country'],
              leagueCountryFlag: allTeamsBody[0]['league']['flag'],
              teamRank: allTeamsBody[0]['league']['standings'][0][j]['rank'],
              teamLogo: allTeamsBody[0]['league']['standings'][0][j]['team']
                  ['logo'],
              teamName: allTeamsBody[0]['league']['standings'][0][j]['team']
                  ['name'],
              teamPlayed: allTeamsBody[0]['league']['standings'][0][j]['all']
                  ['played'],
              teamWin: allTeamsBody[0]['league']['standings'][0][j]['all']
                  ['win'],
              teamDraw: allTeamsBody[0]['league']['standings'][0][j]['all']
                  ['draw'],
              teamLose: allTeamsBody[0]['league']['standings'][0][j]['all']
                  ['lose'],
              teamGoalDiff: allTeamsBody[0]['league']['standings'][0][j]
                  ['goalsDiff'],
              teamPoints: allTeamsBody[0]['league']['standings'][0][j]
                  ['points'],
              teamId: allTeamsBody[0]['league']['standings'][0][j]['team']
                  ['id']);
          // add team standings information from API to list
          teamStandingsModelList.add(team);
        }
        teamStandingsModelList2 = teamStandingsModelList;
        standingsMap.add(teamStandingsModelList);
      });
    }
    for (var standMap in standingsMap) {
      //print(standMap);
      for (int f = 0; f < 1; f++) {
        print(standMap[f].teamName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 75,
        title: Text('Standings',
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
              children: standingsMap
                  .map((standmap) => Container(
                        child: Column(
                          children: [
                            //=========== LEAGUE HEADER SECTION ============
                            ListTile(
                              leading: Container(
                                height: 50,
                                width: 25,
                                child: SvgPicture.network(
                                    standmap[0].leagueCountryFlag),
                              ),
                              title: Text(standmap[0].leagueName,
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              subtitle: Text(standmap[0].leagueCountry,
                                  style: GoogleFonts.rajdhani(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey)),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => standingsDetails(
                                          standmap[0].leagueID)));
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ),
                            ),

                            //=========== SHORT STANDINGS TABLE ===============
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // radius of 10
                                    color: Colors
                                        .grey[850] // green as background color
                                    ),
                                height: 297,
                                width: double.maxFinite,
                                child: DataTable(
                                    columnSpacing: 2,
                                    //================== COLUMNS ==================
                                    columns: [
                                      DataColumn(
                                          label: Text('Team',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('P',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('W',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('D',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('L',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('GD',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                      DataColumn(
                                          label: Text('Pts',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white))),
                                    ],
                                    //============ ROWS ===================
                                    rows: teamStandingsModelList2
                                        .map((team) => DataRow(
                                                /*onSelectChanged: (selected) {
                                      if (selected == true) {
                                        print(team.teamName.toString());
                                      }
                                    },*/
                                                cells: [
                                                  //==========TEAM NAME & LOGO TABLE==============
                                                  DataCell(
                                                    Container(
                                                      height: 18,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                                    //borderRadius: BorderRadius.circular(50),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(team
                                                                            .teamLogo
                                                                            .toString()))),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                              team.teamName
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                      color: Colors
                                                                          .white))
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //======================
                                                  DataCell(Text(
                                                      team.teamPlayed
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                  DataCell(Text(
                                                      team.teamWin.toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                  DataCell(Text(
                                                      team.teamDraw.toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                  DataCell(Text(
                                                      team.teamLose.toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                  DataCell(Text(
                                                      team.teamGoalDiff
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                  DataCell(Text(
                                                      team.teamPoints
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                              color: Colors
                                                                  .white))),
                                                ]))
                                        .toList()),
                              ),
                            )
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
