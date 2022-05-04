import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/fixtures_details_model.dart';
import 'package:my_soccer_academia/models/team_standings_model.dart';
import 'package:my_soccer_academia/pages/fixture.dart';
import 'package:my_soccer_academia/pages/team_details_page.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart';
import 'package:intl/intl.dart';
import 'package:my_soccer_academia/utils/pop_up_message.dart';

class standingsDetails extends StatefulWidget {
  int leagueId = 0;
  standingsDetails(this.leagueId);
  @override
  State<standingsDetails> createState() =>
      _standingsDetailsState(leagueId: this.leagueId);
}

class _standingsDetailsState extends State<standingsDetails>
    with TickerProviderStateMixin {
  _standingsDetailsState({required this.leagueId});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Data init
  int leagueId = 0;
  String leagueName = "";
  String leagueLogo = "";
  int leagueSeason = 0;
  int fixtureId = 721025;
  int season = 2021;

  List<teamStandingsModel> teamStandingsModelList = [];
  late teamStandingsModel team;

  List<fixturesDetails> fixturesDetailsModelList = [];
  late fixturesDetails fixtures;

//Format date from API "2022-04-20T19:30:00+00:00" to "20/04/2022  19:30"
  @override
  String formatDate(String dt) {
    DateTime currentPhoneDate = DateTime.parse(dt);
    String formattedDate =
        DateFormat('dd/MM/yyyy  kk:mm').format(currentPhoneDate);
    return formattedDate;
  }

  @override
  String formatDate_add7() {
    var dt = DateTime.now();
    final dt2 = dt.add(const Duration(days: 20));
    String formattedDate = DateFormat('yyyy-MM-dd').format(dt2);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    getTeams();
    getFixtures();
  }

  void getTeams() async {
    var allTeams = await fetchGetDataList(RequestType.get, '/v3/standings',
        {"league": "$leagueId", "season": "$season"});

    setState(() {
      var allTeamsBody = allTeams.body;
      for (int i = 0; i < allTeamsBody.length; i++) {
        //LEAGUE DATA
        leagueName = allTeamsBody[0]['league']['name'];
        leagueLogo = allTeamsBody[0]['league']['logo'];
        leagueSeason = allTeamsBody[0]['league']['season'];
        var verifLeagueLength = allTeamsBody[0]['league']['standings'][0];

        //TEAMS DATA
        for (int j = 0; j < verifLeagueLength.length; j++) {
          team = teamStandingsModel(
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

          teamStandingsModelList.add(team);
        }
        // add team standings information from API to list
      }
    });
  }

  void getFixtures() async {
    var allTeams = await fetchGetDataList(RequestType.get, '/v3/fixtures', {
      "league": "$leagueId",
      "season": "$season",
      "from": '$season-08-01',
      "to": formatDate_add7()
    });

    //HomeStatus & awayStatus bool
    setState(() {
      var allTeamsBody = allTeams.body;
      for (int i = 0; i < allTeamsBody.length; i++) {
        //FIXTURES DATA
        fixtures = fixturesDetails(
            fixtureID: allTeamsBody[i]['fixture']['id'],
            fixtureDate: formatDate(allTeamsBody[i]['fixture']['date']),
            fixtureStadium: allTeamsBody[i]['fixture']['venue']['name'],
            fixtureStatus: allTeamsBody[i]['fixture']['status']['short'],
            fixtureTime: allTeamsBody[i]['fixture']['status']['elapsed'],
            homeID: allTeamsBody[i]['teams']['home']['id'],
            homeName: allTeamsBody[i]['teams']['home']['name'],
            homeLogo: allTeamsBody[i]['teams']['home']['logo'],
            homeStatus: allTeamsBody[i]['teams']['home']['winner'],
            homeScore: allTeamsBody[i]['goals']['home'],
            awayID: allTeamsBody[i]['teams']['away']['id'],
            awayName: allTeamsBody[i]['teams']['away']['name'],
            awayLogo: allTeamsBody[i]['teams']['away']['logo'],
            awayStatus: allTeamsBody[i]['teams']['away']['winner'],
            awayScore: allTeamsBody[i]['goals']['away'],
            homeStarter: [],
            homeSubtit: [],
            awayStarter: [],
            awaySubtit: []);

        //for (int j = 0; j < 2; j++) {}

        fixturesDetailsModelList.add(fixtures);

        // add team standings information from API to list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.grey[850],
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            //=========== Title & Logo ============
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(50),
                        image:
                            DecorationImage(image: NetworkImage(leagueLogo))),
                  ),
                  Text(
                    leagueName + " " + leagueSeason.toString(),
                    style: GoogleFonts.rajdhani(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
            ),

            //=============== TAB ===================
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(children: [
                Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                      TabBar(
                        indicatorColor: MSAColors.pinkStanding,
                        labelColor: MSAColors.pinkStanding,
                        unselectedLabelColor: Colors.white,
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            text: 'Games',
                          ),
                          Tab(
                            text: 'Table',
                          )
                        ],
                      ),
                    ]),

                //=============== TABVIEW ===================
                Container(
                  width: double.maxFinite,
                  height: 450,
                  child: TabBarView(controller: _tabController, children: [
                    //==================MATCHES ===================

                    Container(
                      height: 450,
                      //color: Colors.amber,
                      child: ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: ListTile.divideTiles(
                            context: context,
                            tiles: fixturesDetailsModelList.map(
                              (fixts) => ListTile(
                                leading: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              fixts.homeLogo.toString()))),
                                ),
                                title: Center(
                                  child: Text(
                                      "${fixts.homeName} - ${fixts.awayName}",
                                      style: GoogleFonts.rajdhani(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                                subtitle: Center(
                                  child: (fixts.fixtureStatus == 'NS')
                                      ? Text(
                                          "${fixts.fixtureDate} UTC / [${fixts.fixtureStadium}] ",
                                          style: GoogleFonts.rajdhani(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey))
                                      : Text(
                                          "${fixts.fixtureStatus} : ${fixts.homeScore} - ${fixts.awayScore} ",
                                          style: GoogleFonts.rajdhani(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey)),
                                ),
                                trailing: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              fixts.awayLogo.toString()))),
                                ),
                                onTap: () {
                                  if (fixts.fixtureStatus != 'NS') {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => fixture(
                                                  fixts.fixtureID,
                                                )));
                                  } else {
                                    PopUpMessage().SnackError(
                                        "Game not started yet !", _scaffoldKey);
                                  }
                                },
                              ),
                            )).toList(),
                      ),
                    ),

                    // =================== TABLE ====================
                    ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        //color: Colors.white,
                        children: [
                          DataTable(
                              columnSpacing: 4,
                              //================== COLUMNS ==================
                              columns: [
                                DataColumn(
                                    label: Text('#',
                                        style: GoogleFonts.rajdhani(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))),
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
                              rows: teamStandingsModelList
                                  .map((team) => DataRow(
                                          /*onSelectChanged: (selected) {
                                    if (selected == true) {
                                      print(team.teamName.toString());
                                    }
                                  },*/
                                          cells: [
                                            DataCell(
                                              Text(team.teamRank.toString(),
                                                  style: GoogleFonts.rajdhani(
                                                      color: Colors.white)),
                                            ),

                                            //==========TEAM NAME & LOGO TABLE==============
                                            DataCell(
                                              Container(
                                                height: 18,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 15,
                                                      width: 15,
                                                      decoration: BoxDecoration(
                                                          //borderRadius: BorderRadius.circular(50),
                                                          image: DecorationImage(
                                                              image: NetworkImage(team
                                                                  .teamLogo
                                                                  .toString()))),
                                                    ),
                                                    const SizedBox(width: 10),
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
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          TeamDetailsPage(
                                                              team.teamId,
                                                              team.teamName,
                                                              team.teamLogo,
                                                              leagueName,
                                                              leagueLogo,
                                                              leagueId))),
                                            ),

                                            //======================
                                            DataCell(Text(
                                                team.teamPlayed.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                            DataCell(Text(
                                                team.teamWin.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                            DataCell(Text(
                                                team.teamDraw.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                            DataCell(Text(
                                                team.teamLose.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                            DataCell(Text(
                                                team.teamGoalDiff.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                            DataCell(Text(
                                                team.teamPoints.toString(),
                                                style: GoogleFonts.rajdhani(
                                                    color: Colors.white))),
                                          ]))
                                  .toList()),
                        ])
                  ]),
                )
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
