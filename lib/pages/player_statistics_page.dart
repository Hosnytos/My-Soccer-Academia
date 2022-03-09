import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/rest/request.dart';

class PlayerStatisticsPage extends StatefulWidget {

  PlayerStatisticsPage(this.selectedPlayerId, this.selectedPlayerName,
      this.playerPicture);

  int selectedPlayerId = 0;
  String selectedPlayerName = "";
  String playerPicture = "";

  @override
  State<StatefulWidget> createState() {
    return _PlayerStatisticsPage(
      selectedPlayerId:this.selectedPlayerId,
      selectedPlayerName:this.selectedPlayerName,
      playerPicture:this.playerPicture,
    );
  }
}

class _PlayerStatisticsPage extends State<PlayerStatisticsPage> {

  _PlayerStatisticsPage({
    required this.selectedPlayerId,
    required this.selectedPlayerName,
    required this.playerPicture,
  });

  int selectedPlayerId = 0;
  String selectedPlayerName = "";
  String playerPicture = "";

  List<String> leagueName = [];
  List<String> leagueLogo = [];
  List<String> leagueCountry = [];
  List<int> leagueAppearances = [];
  List<int> leagueGoals = [];
  List<int> leagueAssists = [];
  List<int> leagueYellowCards = [];
  List<int> leagueRedCards = [];
  List<String> leagueRating = [];
  List<int> leagueMinutes = [];
  List<int> leagueShotTarget = [];
  List<int> leagueShotTotal = [];
  List<int> leagueKeyPasses = [];
  List<int> leagueKeyPassesTotal = [];
  List<int> leagueTackles = [];
  List<int> leagueDuelsWon = [];
  List<int> leagueDuelsTotal = [];
  List<int> leagueSuccessfulDribbles = [];
  List<int> leagueDribblesTotal = [];
  List<int> leagueCommittedFouls = [];


  @override
  void initState() {
    super.initState();
    getPlayerStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Season 2021 - " + selectedPlayerName,
          style: const TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }

  void getPlayerStatistics() async{
    var myTeamStats = await fetchGetDataList(
        RequestType.get,
        '/v3/players',
        {
          "id" : "$selectedPlayerId",
          "season": "2021",
        });

    setState(() {
      var myPlayerStatsBody = myTeamStats.body[0]['statistics'];
      for(int i = 0; i <4; i++ ){
        leagueName.add(myPlayerStatsBody[i]['league']['name']);
        leagueLogo.add(myPlayerStatsBody[i]['league']['logo'] ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Football-Cup.svg/682px-Football-Cup.svg.png");
        leagueCountry.add(myPlayerStatsBody[i]['league']['country']  ?? "World");
        leagueAppearances.add(myPlayerStatsBody[i]['games']['appearences'] ?? 0);
        leagueGoals.add(myPlayerStatsBody[i]['goals']['total'] ?? 0) ;
        leagueAssists.add(myPlayerStatsBody[i]['goals']['assists'] ?? 0);
        leagueYellowCards.add(myPlayerStatsBody[i]['cards']['yellow'] ?? 0);
        leagueRedCards.add(myPlayerStatsBody[i]['cards']['red'] ?? 0);
        leagueRating.add(myPlayerStatsBody[i]['games']['rating'] ?? "0") ;
        leagueMinutes.add(myPlayerStatsBody[i]['games']['minutes'] ?? 0);
        leagueShotTarget.add(myPlayerStatsBody[i]['shots']['on'] ?? 0) ;
        leagueShotTotal.add(myPlayerStatsBody[i]['shots']['total'] ?? 0) ;
        leagueKeyPasses.add(myPlayerStatsBody[i]['passes']['key'] ?? 0) ;
        leagueKeyPassesTotal.add(myPlayerStatsBody[i]['passes']['total'] ?? 0);
        leagueTackles.add(myPlayerStatsBody[i]['tackles']['total'] ?? 0);
        leagueDuelsWon.add(myPlayerStatsBody[i]['duels']['won'] ?? 0);
        leagueDuelsTotal.add(myPlayerStatsBody[i]['duels']['total'] ?? 0) ;
        leagueSuccessfulDribbles.add(myPlayerStatsBody[i]['dribbles']['success'] ?? 0) ;
        leagueDribblesTotal.add(myPlayerStatsBody[i]['dribbles']['attempts'] ?? 0) ;
        leagueCommittedFouls.add(myPlayerStatsBody[i]['fouls']['committed'] ?? 0) ;
      }
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
            _playerPicture(),
          ],
        ),
      ),
    );
  }

  Widget _playerPicture(){
    return Container(
      width: 200.0,
      height: 180.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(12.0)),
        image: DecorationImage(
            image: NetworkImageWithRetry(
                playerPicture),
            fit: BoxFit.contain),
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
                _competitionInfo(),
                _largeDivider(),
                getBody(),
                _largeDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _competitionInfo(){
    return const Padding(
      padding: EdgeInsets.only(top : 18, bottom : 18),
      child: Text(
        "Competition Info",
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

  // Main League Expansion Tile/ /

  Widget getBody(){
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: leagueName.length,
        itemBuilder: (context, index){
          return _tileBody(index);
        });
  }

  Widget _tileBody(index){
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.transparent
            ),
            child: _mainLeagueTile(index)
        ),
        _largeDivider()
      ]
    );
  }

  Widget _mainLeagueTile(index){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ExpansionTile(
        title: Text(
          leagueName[index],
          style: const TextStyle(
              color: Colors.black, fontSize: 18),
        ),
        children: <Widget>[
          _leagueLogo(index),
          _largeDivider(),
          _leagueAppearances(index),
          _largeDivider(),
          _leagueGoals(index),
          _largeDivider(),
          _leagueAssists(index),
          _largeDivider(),
          _leagueYellowCards(index),
          _largeDivider(),
          _leagueRedCards(index),
          _largeDivider(),
          _leagueRating(index),
          _largeDivider(),
          _leagueMinutes(index),
          _largeDivider(),
          _leagueShotTarget(index),
          _largeDivider(),
          _leagueKeyPasses(index),
          _largeDivider(),
          _leagueTackles(index),
          _largeDivider(),
          _leagueDuels(index),
          _largeDivider(),
          _leagueDribbles(index),
          _largeDivider(),
          _leagueCommittedFouls(index),
          _largeDivider(),
        ],
      ),
    );
  }

  Widget _leagueLogo(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8 , bottom: 8.0),
      child: Column(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(12.0)),
              image: DecorationImage(
                  image: NetworkImageWithRetry(
                      leagueLogo[index]),
                  fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 15),
            child: Text(leagueCountry[index]),
          ),
        ],
      ),
    );
  }

  Widget _leagueAppearances(index) {
    int myAppearance = leagueAppearances[index];
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 87.0),
          child: Text("Appearances :"),
        ),
        Text("$myAppearance")
      ],
    );
  }

  Widget _leagueGoals(index) {
    int myTotalGoals = leagueGoals[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 133.0),
          child: Text("Goals :"),
        ),
        Text("$myTotalGoals")
      ],
    );
  }

  Widget _leagueAssists(index) {
    int myLeagueAssists = leagueAssists[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 124.0),
          child: Text("Assists :"),
        ),
        Text("$myLeagueAssists")
      ],
    );
  }

  Widget _leagueYellowCards(index) {
    int myLeagueYellowCards = leagueYellowCards[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 92.0),
          child: Text("Yellow cards :"),
        ),
        Text("$myLeagueYellowCards")
      ],
    );
  }

  Widget _leagueRedCards(index) {
    int myLeagueRedCards = leagueRedCards[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 110.0),
          child: Text("Red cards :"),
        ),
        Text("$myLeagueRedCards")
      ],
    );
  }

  Widget _leagueRating(index) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 132.0),
          child: Text("Rating :"),
        ),
        Text(leagueRating[index])
      ],
    );
  }

  Widget _leagueMinutes(index) {
    int myLeagueMinutes = leagueMinutes[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 121.0),
          child: Text("Minutes :"),
        ),
        Text("$myLeagueMinutes")
      ],
    );
  }

  Widget _leagueShotTarget(index) {
    int myLeagueShotTarget = leagueShotTarget[index];
    int myLeagueShotTotal = leagueShotTotal[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 84.0),
          child: Text("Shot on target :"),
        ),
        Text("$myLeagueShotTarget/$myLeagueShotTotal")
      ],
    );
  }

  Widget _leagueKeyPasses(index) {
    int myLeagueKeyPasses = leagueKeyPasses[index];
    int myLeagueKeyPassesTotal = leagueKeyPassesTotal[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 103.0),
          child: Text("Key passes :"),
        ),
        Text("$myLeagueKeyPasses/$myLeagueKeyPassesTotal")
      ],
    );
  }

  Widget _leagueTackles(index) {
    int myLeagueTackles = leagueTackles[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 126.0),
          child: Text("Tackles :"),
        ),
        Text("$myLeagueTackles")
      ],
    );
  }

  Widget _leagueDuels(index) {
    int myLeagueDuelsWon = leagueDuelsWon[index];
    int myLeagueDuelsTotal = leagueDuelsTotal[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 108.0),
          child: Text("Duels won :"),
        ),
        Text("$myLeagueDuelsWon/$myLeagueDuelsTotal")
      ],
    );
  }

  Widget _leagueDribbles(index) {
    int myLeagueSuccessfulDribbles = leagueSuccessfulDribbles[index];
    int myLeagueDribblesTotal = leagueDribblesTotal[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 52.0),
          child: Text("Successful dribbles :"),
        ),
        Text("$myLeagueSuccessfulDribbles/$myLeagueDribblesTotal")
      ],
    );
  }

  Widget _leagueCommittedFouls(index) {
    int myLeagueCommittedFouls = leagueCommittedFouls[index];

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 70.0),
          child: Text("Committed fouls :"),
        ),
        Text("$myLeagueCommittedFouls")
      ],
    );
  }
}