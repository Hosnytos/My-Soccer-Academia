import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/fixtures_details_model.dart';
import 'package:my_soccer_academia/models/team_standings_model.dart';
import 'package:my_soccer_academia/pages/team_details_page.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:intl/intl.dart';

class fixture extends StatefulWidget {
  int leagueId = 0;
  int fixtureId = 721066;
  fixture(this.fixtureId);

  @override
  State<fixture> createState() => _fixtureState(fixtureId: this.fixtureId);
}

class _fixtureState extends State<fixture> with TickerProviderStateMixin {
  _fixtureState({required this.fixtureId});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Data init
  int leagueId = 140;
  String leagueName = "";
  String leagueLogo = "";
  int leagueSeason = 0;
  int fixtureId = 721066;

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
    getFixtures();
  }

  void getFixtures() async {
    var allTeams = await fetchGetDataList(RequestType.get, '/v3/fixtures', {
      "id": "$fixtureId",
    });

    //HomeStatus & awayStatus bool
    setState(() {
      var allTeamsBody = allTeams.body;
      for (int i = 0; i < 1; i++) {
        leagueName = allTeamsBody[0]['league']['name'];
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
          homeCoachName: allTeamsBody[i]['lineups'][0]['coach']['name'],
          homeCoachPhoto: allTeamsBody[i]['lineups'][0]['coach']['photo'],
          homeFormation: allTeamsBody[i]['lineups'][0]['formation'],
          homeShots: allTeamsBody[i]['statistics'][0]['statistics'][2]['value'],
          homeShotsOnGoal: allTeamsBody[i]['statistics'][0]['statistics'][0]
              ['value'],
          homeBallPossession: allTeamsBody[i]['statistics'][0]['statistics'][9]
              ['value'],
          homePasses: allTeamsBody[i]['statistics'][0]['statistics'][15]
              ['value'],
          homeFouls: allTeamsBody[i]['statistics'][0]['statistics'][6]['value'],
          homeYellowCards: (allTeamsBody[i]['statistics'][0]['statistics'][10]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][0]['statistics'][10]['value']
              : 0,
          homeRedCards: (allTeamsBody[i]['statistics'][0]['statistics'][11]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][0]['statistics'][11]['value']
              : 0,
          homeCorners: (allTeamsBody[i]['statistics'][0]['statistics'][7]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][0]['statistics'][7]['value']
              : 0,
          homeStarter: [],
          homeSubtit: [],
          awayID: allTeamsBody[i]['teams']['away']['id'],
          awayName: allTeamsBody[i]['teams']['away']['name'],
          awayLogo: allTeamsBody[i]['teams']['away']['logo'],
          awayStatus: allTeamsBody[i]['teams']['away']['winner'],
          awayScore: allTeamsBody[i]['goals']['away'],
          awayCoachName: allTeamsBody[i]['lineups'][1]['coach']['name'],
          awayCoachPhoto: allTeamsBody[i]['lineups'][1]['coach']['photo'],
          awayFormation: allTeamsBody[i]['lineups'][1]['formation'],
          awayShots: allTeamsBody[i]['statistics'][1]['statistics'][2]['value'],
          awayShotsOnGoal: allTeamsBody[i]['statistics'][1]['statistics'][0]
              ['value'],
          awayBallPossession: allTeamsBody[i]['statistics'][1]['statistics'][9]
              ['value'],
          awayPasses: allTeamsBody[i]['statistics'][1]['statistics'][15]
              ['value'],
          awayFouls: allTeamsBody[i]['statistics'][1]['statistics'][6]['value'],
          awayYellowCards: (allTeamsBody[i]['statistics'][1]['statistics'][10]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][1]['statistics'][10]['value']
              : 0,
          awayRedCards: (allTeamsBody[i]['statistics'][1]['statistics'][11]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][1]['statistics'][11]['value']
              : 0,
          awayCorners: (allTeamsBody[i]['statistics'][1]['statistics'][7]
                      ['value'] !=
                  null)
              ? allTeamsBody[i]['statistics'][1]['statistics'][7]['value']
              : 0,
          awayStarter: [],
          awaySubtit: [],
          onFav: false,
        );
        //Starter
        for (int j = 0; j < 11; j++) {
          fixtures.homeStarter.add(allTeamsBody[i]['lineups'][0]['startXI'][j]
                      ['player']['number']
                  .toString() +
              " " +
              allTeamsBody[i]['lineups'][0]['startXI'][j]['player']['name']);

          fixtures.awayStarter.add(allTeamsBody[i]['lineups'][1]['startXI'][j]
                  ['player']['name'] +
              ' ' +
              allTeamsBody[i]['lineups'][1]['startXI'][j]['player']['number']
                  .toString());
        }

        //Subtitles HOME
        for (int k = 0;
            k < allTeamsBody[i]['lineups'][0]['substitutes'].length;
            k++) {
          fixtures.homeSubtit.add(allTeamsBody[i]['lineups'][0]['substitutes']
                      [k]['player']['number']
                  .toString() +
              " " +
              allTeamsBody[i]['lineups'][0]['substitutes'][k]['player']
                  ['name']);
        }

        //Subtitles AWAY
        for (int l = 0;
            l < allTeamsBody[i]['lineups'][1]['substitutes'].length;
            l++) {
          fixtures.awaySubtit.add(allTeamsBody[i]['lineups'][1]['substitutes']
                  [l]['player']['name'] +
              ' ' +
              allTeamsBody[i]['lineups'][1]['substitutes'][l]['player']
                      ['number']
                  .toString());
        }

        //for (int j = 0; j < 2; j++) {}

        fixturesDetailsModelList.add(fixtures);
        print(leagueName);

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
        titleSpacing: 75,
        title: Text(leagueName,
            style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.blueGrey[100],
        child: ListView(
          children: [
            //Score Section

            Expanded(
              flex: 3,
              child: Container(
                  height: 175,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/msa_stadium.jpg'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black54, BlendMode.darken),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => TeamDetailsPage(
                                        fixturesDetailsModelList[0].homeID,
                                        fixturesDetailsModelList[0]
                                            .homeName
                                            .toString(),
                                        fixturesDetailsModelList[0]
                                            .homeLogo
                                            .toString(),
                                        leagueName,
                                        leagueLogo,
                                        leagueId))),
                            child: Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          fixturesDetailsModelList[0]
                                              .homeLogo
                                              .toString()))),
                            ),
                          ),
                          Text(
                              "${fixturesDetailsModelList[0].homeScore} - ${fixturesDetailsModelList[0].awayScore}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => TeamDetailsPage(
                                        fixturesDetailsModelList[0].awayID,
                                        fixturesDetailsModelList[0]
                                            .awayName
                                            .toString(),
                                        fixturesDetailsModelList[0]
                                            .awayLogo
                                            .toString(),
                                        leagueName,
                                        leagueLogo,
                                        leagueId))),
                            child: Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          fixturesDetailsModelList[0]
                                              .awayLogo
                                              .toString()))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeName}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text(
                              "${fixturesDetailsModelList[0].fixtureTime} ${fixturesDetailsModelList[0].fixtureStatus}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.greenAccent)),
                          Text(" ${fixturesDetailsModelList[0].awayName}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 25,
            ),

            //Details Fixtures

            Expanded(
              flex: 5,
              child: Container(
                  height: 1100,
                  width: double.infinity,
                  child: Wrap(
                    runSpacing: 8,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: Text("Match Details",
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),
                      //==== SHOTS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeShots}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("Shots",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayShots}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                      //==== SHOTS ON GOALS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeShotsOnGoal}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("Shots On Goal",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(
                              " ${fixturesDetailsModelList[0].awayShotsOnGoal}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                      //==== POSSESSION ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${fixturesDetailsModelList[0].homeBallPossession}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("Posssession",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(
                              " ${fixturesDetailsModelList[0].awayBallPossession}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      //==== PASSES ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homePasses}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("PASSES",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayPasses}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      //==== FOULS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeFouls}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("FOULS",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayFouls}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      //==== YELLOW CARDS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeYellowCards}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("🟨 Yellow Cards ",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(
                              " ${fixturesDetailsModelList[0].awayYellowCards}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      //==== RED CARDS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeRedCards}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("🟥 Red Cards ",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayRedCards}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      //==== CORNERS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeCorners}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("Corners",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayCorners}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      Center(
                        child: Text("Teams Info",
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),

                      //==== FORMATION ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeFormation}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text("Formation",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayFormation}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      Center(
                        child: Text("Coach",
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),

                      //==== COACHS ====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${fixturesDetailsModelList[0].homeCoachName}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(" ${fixturesDetailsModelList[0].awayCoachName}",
                              style: GoogleFonts.rajdhani(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),
                      //======== STARTERS ===========
                      Center(
                        child: Text("Starters",
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: fixturesDetailsModelList[0]
                                  .homeStarter
                                  .map((e) => Container(
                                        child: Text(e,
                                            style: GoogleFonts.rajdhani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: fixturesDetailsModelList[0]
                                  .awayStarter
                                  .map((e) => Container(
                                        child: Text(e,
                                            style: GoogleFonts.rajdhani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                            ),
                          ]),

                      const SizedBox(
                        height: 10,
                      ),

                      //======== SUBTITIONS ===========
                      Center(
                        child: Text("Substitutes",
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: fixturesDetailsModelList[0]
                                  .homeSubtit
                                  .map((e) => Container(
                                        child: Text(e,
                                            style: GoogleFonts.rajdhani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: fixturesDetailsModelList[0]
                                  .awaySubtit
                                  .map((e) => Container(
                                        child: Text(e,
                                            style: GoogleFonts.rajdhani(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                            ),
                          ]),
                    ],
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
