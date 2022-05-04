import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/models/fixtures_details_model.dart';
import 'package:my_soccer_academia/models/team_standings_model.dart';
import 'package:my_soccer_academia/pages/search_results.dart';
import 'package:my_soccer_academia/pages/standings.dart';
import 'package:my_soccer_academia/pages/standings_details.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart' as msa_color;

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String leagueName = "";
  String leagueLogo = "";
  int leagueId = 141;
  int teamId = 541;
  bool notifAdd = false;
  String searchResu = "";

  int fixtureId = 721025;
  int season = 2021;

  List<String> leagueNameList = [];
  List<String> leagueLogoList = [];
  List<int> leagueIdList = [];
  List<int> listFavLeague = [ 39, 40, 78, 79, 140, 141, 61, 62, 135, 136, 424];

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
    getLeague();
    getFixtures();
  }

  void getLeague() async {
    var leagueFetch =
        await fetchGetDataList(RequestType.get, '/v3/leagues', {"": ""});

    if (mounted) {
      setState(() {
        for (int i = 0; i < leagueFetch.body.length; i++) {
          List<int> leagueBodyId = [];
          leagueBodyId.add(leagueFetch.body[i]['league']['id']);
          for (int j = 0; j < listFavLeague.length; j++) {
            if (leagueBodyId.contains(listFavLeague[j])) {
              leagueNameList.add(leagueFetch.body[i]['league']['name']);
              leagueLogoList.add(leagueFetch.body[i]['league']['logo']);
              leagueIdList.add(leagueFetch.body[i]['league']['id']);
            }
          }
        }
      });
    }
  }

  void getFixtures() async {
    var allTeams = await fetchGetDataList(RequestType.get, '/v3/fixtures', {
      "season": "$season",
      "team": "$teamId",
      "next": '10',
    });

    //HomeStatus & awayStatus bool
    setState(() {
      var allTeamsBody = allTeams.body;
      for (int i = 0; i < allTeamsBody.length; i++) {
        //FIXTURES DATA
        fixtures = fixturesDetails(
            onFav: false,
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Container(
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search a Team  here",
                labelStyle: GoogleFonts.rajdhani(
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 15)),
              ),
              style: const TextStyle(
                  fontSize: 14.0, height: 2.0, color: Colors.white),
              onChanged: (value) {
                searchResu = value;
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => searchResult(searchResu)));
            },
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white30,
              size: 30,
            ),
          )
        ],
        backgroundColor: msa_color.MSAColors.bottomNavBar,
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        color: Colors.grey[850],
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            //=========== LEAGUES SECTION ==============================
            Container(
              margin: const EdgeInsets.only(top: 45, left: 18),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0)),
                color: msa_color.MSAColors.darkGrey,
              ),
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 20, top: 25),
                child: Column(
                  children: [
                    // Leagues title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Leagues",
                          style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => standings()));
                          },
                          child: Text(
                            "View All",
                            style: GoogleFonts.rajdhani(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white30),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      height: 75,
                      //color: Colors.redAccent,
                      margin: const EdgeInsets.only(top: 25),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                  itemCount: leagueLogoList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () => {
                                          leagueId = leagueIdList[index],
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      standingsDetails(
                                                          leagueId)))
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          height: 70,
                                          width: 72,
                                          decoration: BoxDecoration(
                                              //borderRadius: BorderRadius.circular(50),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      leagueLogoList[index]))),
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //=========== LIVES MATCHES ==================
            Container(
              margin: const EdgeInsets.only(top: 25),
              height: 350,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 20, top: 25),
                child: Column(
                  children: [
                    // Leagues title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Live Matches",
                          style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            print('Text Clicked [view all2]');
                          },
                          child: Text(
                            "View All",
                            style: GoogleFonts.rajdhani(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white30),
                          ),
                        ),
                      ],
                    ),

                    //Lives games section
                    Container(
                      height: 250,
                      margin: const EdgeInsets.only(top: 25),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  itemCount: leagueLogoList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () => {
                                          leagueName = leagueNameList[index],
                                          print(leagueName)
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          height: 200,
                                          width: 170,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blue[600]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 20,
                                                top: 20),
                                            child: Column(
                                              children: [
                                                //Live green point
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Center(
                                                          child: Text(
                                                        "Live",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .blue),
                                                      )),
                                                    ),
                                                    const Icon(
                                                      Icons.brightness_1,
                                                      color: Colors.greenAccent,
                                                      size: 12,
                                                    )
                                                  ],
                                                ),

                                                //Teams Logos
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30, bottom: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                                //borderRadius: BorderRadius.circular(50),
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        leagueLogoList[
                                                                            index]))),
                                                      ),
                                                      Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                                //borderRadius: BorderRadius.circular(50),
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        leagueLogoList[
                                                                            index]))),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Team1 Names & Scores
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      child: Text(
                                                        leagueNameList[index],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 20,
                                                      child: Text(
                                                        "0",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                //Teams 2 name & score
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      child: Text(
                                                        leagueNameList[index],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 20,
                                                      child: Text(
                                                        "4",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //UPCOMING GAMES FROM FAV TEAM
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: const Divider(
                            color: Colors.grey,
                            height: 50,
                            thickness: 0.5,
                          )),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size:
                          15.0, // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                    ),
                    Text(
                      " Upcoming",
                      style: GoogleFonts.rajdhani(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: const Divider(
                            color: Colors.grey,
                            height: 50,
                            thickness: 0.5,
                          )),
                    ),
                  ],
                ),
              ],
            ),

            Wrap(
              runSpacing: 20,
              children: fixturesDetailsModelList
                  .map(
                    (fixt) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundImage:
                                    NetworkImage(fixt.homeLogo.toString()),
                                backgroundColor: Colors.blueGrey,
                              ),
                            ),
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundImage:
                                    NetworkImage(fixt.awayLogo.toString()),
                                backgroundColor: Colors.blueGrey,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${fixt.homeName} - ${fixt.awayName} ",
                                style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14)),
                            Text("${fixt.fixtureDate} UTC ",
                                style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 10)),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.05)),
                          ),
                          onPressed: () {
                            setState(() {
                              if (fixt.onFav == false) {
                                fixt.onFav = true;
                              } else {
                                fixt.onFav = false;
                              }
                            });
                          },
                          child: Icon(
                            Icons.notifications_active,
                            color: (fixt.onFav == false)
                                ? Colors.white
                                : Colors.pinkAccent,
                            size:
                                20.0, // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      )),
    );
  }
}
