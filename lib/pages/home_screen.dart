import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/pages/searchDelegate.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart' as msa_color;

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String leagueName = "";
  String leagueLogo = "";
  int leagueId = 0;

  List<String> leagueNameList = [];
  List<String> leagueLogoList = [];
  List<int> leagueIdList = [];
  List<int> listFavLeague = [1, 39, 78, 140, 61, 135, 424];

  @override
  void initState() {
    super.initState();
    getLeague();
  }

  void getLeague() async {
    var leagueFetch =
        await fetchGetDataList(RequestType.get, '/v3/leagues', {"": ""});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          "assets/msa_logo.png",
          height: 35,
          width: 45,
        ),
        titleSpacing: 100,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: searchDelegate(),
              );
            },
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white30,
              size: 30,
            ),
          )
        ],
        backgroundColor: Colors.grey[850],
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
                            print('Text Clicked [view all]');
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
                                          leagueName = leagueNameList[index],
                                          print(leagueName)
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
                                                      color: Colors.green,
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
            //TEST SCROLL HERE
          ],
        ),
      )),
    );
  }
}
