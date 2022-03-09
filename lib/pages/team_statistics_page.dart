import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/rest/request.dart';

class TeamStatisticsPage extends StatefulWidget {

  TeamStatisticsPage(this.leagueName, this.leagueLogo, this.selectedTeamId,
      this.leagueId, this.selectedTeamName, this.selectedTeamLogo);

  String leagueName = "";
  String leagueLogo = "";
  int selectedTeamId = 0;
  int leagueId = 0;
  String selectedTeamName = "";
  String selectedTeamLogo = "";

  @override
  _TeamStatisticsPageState createState() => _TeamStatisticsPageState(
      leagueName:this.leagueName,
      leagueLogo:this.leagueLogo,
      selectedTeamId:this.selectedTeamId,
      leagueId:this.leagueId,
      selectedTeamName:this.selectedTeamName,
      selectedTeamLogo:this.selectedTeamLogo
  );
}

class _TeamStatisticsPageState extends State<TeamStatisticsPage> {

  _TeamStatisticsPageState({required this.leagueName,
    required this.leagueLogo,
    required this.selectedTeamId,
    required this.leagueId,
    required this.selectedTeamName,
    required this.selectedTeamLogo
  });

  String leagueName = "";
  String leagueLogo = "";
  int selectedTeamId = 0;
  int leagueId = 0;
  String selectedTeamName = "";
  String selectedTeamLogo = "";

  int fixturesTotal = 0;
  int winH = 0;
  int winA = 0;
  int winTotal = 0;
  int drawsH = 0;
  int drawsA = 0;
  int drawsHTotal = 0;
  int lostH = 0;
  int lostA = 0;
  int lostTotal = 0;
  int cleanSheetTotal = 0;
  int goalScoredH = 0;
  int goalScoredA = 0;
  int goalScoredTotal = 0;
  int goalConcededH = 0;
  int goalConcededA = 0;
  int goalConcededTotal = 0;
  String lineup = "";
  int penaltyScoredTotal = 0;
  int penaltyMissedTotal = 0;

  @override
  void initState() {
    super.initState();
    getTeamStatistics();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Season 2021 - Statistics", style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }

  void getTeamStatistics() async{
    var myTeamStats = await fetchGetDataMap(
        RequestType.get,
        '/v3/teams/statistics',
        {
          "league" : "$leagueId",
          "season": "2021",
          "team": "$selectedTeamId"
        });

    setState(() {
      var myTeamStatsBody = myTeamStats.body['response'];
      fixturesTotal = myTeamStatsBody['fixtures']['played']['total'];
      winH = myTeamStatsBody['fixtures']['wins']['home'];
      winA = myTeamStatsBody['fixtures']['wins']['away'];
      winTotal = myTeamStatsBody['fixtures']['wins']['total'];
      drawsH = myTeamStatsBody['fixtures']['draws']['home'];
      drawsA = myTeamStatsBody['fixtures']['draws']['away'];
      drawsHTotal = myTeamStatsBody['fixtures']['draws']['total'];
      lostH = myTeamStatsBody['fixtures']['loses']['home'];
      lostA = myTeamStatsBody['fixtures']['loses']['away'];
      lostTotal = myTeamStatsBody['fixtures']['loses']['total'];
      cleanSheetTotal = myTeamStatsBody['clean_sheet']['total'];
      goalScoredH = myTeamStatsBody['goals']['for']['total']['home'];
      goalScoredA = myTeamStatsBody['goals']['for']['total']['away'];
      goalScoredTotal = myTeamStatsBody['goals']['for']['total']['total'];
      goalConcededH = myTeamStatsBody['goals']['against']['total']['home'];
      goalConcededA = myTeamStatsBody['goals']['against']['total']['away'];
      goalConcededTotal = myTeamStatsBody['goals']['against']['total']['total'];
      lineup = myTeamStatsBody['lineups'][0]['formation'];
      penaltyScoredTotal = myTeamStatsBody['penalty']['scored']['total'];
      penaltyMissedTotal = myTeamStatsBody['penalty']['missed']['total'];
    });
  }

  Widget _pageBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/msa_stadium.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black54, BlendMode.darken
          ),
        ),
      ),
      child: Column(
        children: [
          _mainExpanded(),
          _secondaryExpanded()
        ],
      ),
    );
  }

  Widget _mainExpanded(){
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _teamLogo(),
            _teamName(),
          ],
        ),
      ),
    );
  }

  Widget _secondaryExpanded(){
    return Expanded(
      flex: 5,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _teamInfo(),
                _largeDivider(),
                _leagueLogo(),
                _largeDivider(),
                _totalFixtures(),
                _largeDivider(),
                _totalWins(),
                _largeDivider(),
                _totalDraws(),
                _largeDivider(),
                _totalLost(),
                _largeDivider(),
                _cleanSheet(),
                _largeDivider(),
                _goalScored(),
                _largeDivider(),
                _goalConceded(),
                _largeDivider(),
                _lineup(),
                _largeDivider(),
                _penaltyScored(),
                _largeDivider(),
                _penaltyMissed(),
                _largeDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _teamLogo(){
    return Container(
      width: 180.0,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(0.0)),
        image: DecorationImage(
            image: NetworkImageWithRetry(
                selectedTeamLogo),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget _teamName(){
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Text(
        selectedTeamName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _teamInfo(){
    return const Padding(
      padding: EdgeInsets.only(top : 18, bottom : 18),
      child: Text(
        "Team Stats",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget _largeDivider() {
    return const Divider(
      color: Colors.black38,
      thickness: 0.5,
      height: 5,
      indent: 0,
      endIndent: 0,
    );
  }

  // Team statistics / /

  Widget _leagueLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 8 , bottom: 8.0),
      child: Column(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(0.0)),
              image: DecorationImage(
                  image: NetworkImageWithRetry(
                      leagueLogo),
                  fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 15),
            child: Text(leagueName),
          ),
        ],
      ),
    );
  }

  Widget _totalFixtures() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 111.0),
          child: Text("Fixtures :"),
        ),
        Text("$fixturesTotal")
      ],
    );
  }

  Widget _totalWins() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 99.0),
          child: Text("Win  h/a/t :"),
        ),
        Text("$winH / $winA / $winTotal")
      ],
    );
  }

  Widget _totalDraws() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 83),
          child: Text("Draws  h/a/t :"),
        ),
        Text("$drawsH / $drawsA / $drawsHTotal")
      ],
    );
  }

  Widget _totalLost() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 95.0),
          child: Text("Lost  h/a/t :"),
        ),
        Text("$lostH / $lostA / $lostTotal")
      ],
    );
  }

  Widget _cleanSheet() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 89.0),
          child: Text("Clean sheet :"),
        ),
        Text("$cleanSheetTotal")
      ],
    );
  }

  Widget _goalScored() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 49.0),
          child: Text("Goal scored  h/a/t :"),
        ),
        Text("$goalScoredH / $goalScoredA / $goalScoredTotal")
      ],
    );
  }

  Widget _goalConceded() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 30.0),
          child: Text("Goal conceded  h/a/t :"),
        ),
        Text("$goalConcededH / $goalConcededA / $goalConcededTotal")
      ],
    );
  }

  Widget _lineup() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 122.0),
          child: Text("Lineup :"),
        ),
        Text(lineup)
      ],
    );
  }

  Widget _penaltyScored() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 73.0),
          child: Text("Penalty scored :"),
        ),
        Text("$penaltyScoredTotal")
      ],
    );
  }

  Widget _penaltyMissed() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 70.0),
          child: Text("Penalty missed :"),
        ),
        Text("$penaltyMissedTotal")
      ],
    );
  }

}