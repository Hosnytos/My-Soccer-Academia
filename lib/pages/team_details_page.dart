import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/squad_page.dart';
import 'package:my_soccer_academia/pages/team_statistics_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

class TeamDetailsPage extends StatefulWidget {

  TeamDetailsPage(this.selectedTeamId);

  int selectedTeamId = 0;

  @override
  _TeamDetailsPageState createState() => _TeamDetailsPageState(
      selectedTeamId:this.selectedTeamId
  );
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {

  _TeamDetailsPageState({
    required this.selectedTeamId
  });

  int selectedTeamId = 0;
  String selectedTeamName = "";
  String selectedTeamLogo = "";

  String teamCountry = "";
  int teamFounded = 0;
  String teamLogo = "";
  String stadiumName = "";
  int stadiumCapacity = 0;
  String stadiumSurface = "grass";
  String stadiumPicture = "";
  String stadiumAddress = "";
  String stadiumCity = "";
  String leagueName = "";
  int leagueId = 0;
  String leagueLogo = "";


  @override
  void initState() {
    super.initState();
    getTeamInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTeamName, style: const TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }

  void getTeamInfo() async{
    var myTeamInfo = await fetchGetDataList(
        RequestType.get,
        '/v3/teams',
        {
          "id": "$selectedTeamId"
        });

    teamCountry = myTeamInfo.body[0]['team']['country'];
    var myLeagueInfo = await fetchGetDataList(
        RequestType.get,
        '/v3/leagues',
        {
          "country": teamCountry
        });

    setState(() {
      var teamBody = myTeamInfo.body[0]['team'];
      var venueBody = myTeamInfo.body[0]['venue'];


      teamFounded = teamBody['founded'];
      teamLogo = teamBody['logo'];
      stadiumName = venueBody['name'];
      stadiumCapacity = venueBody['capacity'];
      stadiumSurface = venueBody['surface'];
      stadiumPicture = venueBody['image'];
      stadiumAddress = venueBody['address'];
      stadiumCity = venueBody['city'];
      selectedTeamName = teamBody['name'];
      selectedTeamLogo = teamBody['logo'];

      var leagueBody = myLeagueInfo.body[0]['league'];
      leagueName = leagueBody['name'];
      leagueId = leagueBody['id'];
      leagueLogo = leagueBody['logo'];
    });
  }

  Widget _pageBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImageWithRetry(stadiumPicture),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
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
                _teamInfoTitle(),
                _largeDivider(),
                _teamPresentationTile(),
                _largeDivider(),
                _teamStadiumTile(),
                _largeDivider(),
                _teamAddressTile(),
                _largeDivider(),
                _buttonRow()
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
                teamLogo),
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

  Widget _teamInfoTitle(){
    return const Padding(
      padding: EdgeInsets.only(top : 18, bottom : 18),
      child: Text(
        "Team Info",
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
        indent: 10,
        endIndent: 10,
      );
  }

  Widget _teamPresentationTile() {
    return ExpansionTile(
      title: const Text(
        "Information",
        style: TextStyle(
            color: Colors.black, fontSize: 18),
      ),
      children: <Widget>[
        _teamInfoRow()
      ],
    );
  }

  Widget _teamInfoRow(){
    return Row(
      children: [
        _teamInfoText(),
        _teamInfo()
      ],
    );
  }

  Widget _teamInfoText(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Name :"),
          Text("Country :"),
          Text("Founded :"),
          Text("Logo :"),
        ],
      ),
    );
  }

  Widget _teamInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(selectedTeamName),
        Text(teamCountry),
        Text("$teamFounded"),
        _teamLogoRow()
      ],
    );
  }

  Widget _teamLogoRow(){
    return Container(
      width: 28.0,
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(0.0)),
        image: DecorationImage(
            image: NetworkImageWithRetry(
                teamLogo),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget _teamStadiumTile(){
    return ExpansionTile(
      title: const Text(
        "Stadium",
        style: TextStyle(
            color: Colors.black, fontSize: 18),
      ),
      children: <Widget>[
        _teamStadiumRow()
      ],
    );
  }

  Widget _teamStadiumRow(){
    return Row(
      children: [
        _teamStadiumText(),
        _teamStadium()
      ],
    );
  }

  Widget _teamStadiumText(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Name :"),
          Text("Capacity :"),
          Text("Surface :"),
          Text("Image :"),
        ],
      ),
    );
  }

  Widget _teamStadium(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stadiumName),
        Text("$stadiumCapacity"),
        _stadiumSurface(),
        _stadiumPicture()
      ],
    );
  }

  Widget _stadiumSurface() {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return
        Text(capitalize(stadiumSurface)
        );
  }

  Widget _stadiumPicture(){
    return Container(
      width: 28.0,
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(12.0)),
        image: DecorationImage(
            image: NetworkImageWithRetry(
                stadiumPicture),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget _teamAddressTile() {
    return ExpansionTile(
      title: const Text(
        "Address",
        style: TextStyle(
            color: Colors.black, fontSize: 18),
      ),
      children: <Widget>[
        _teamAddress()
      ],
    );
  }

  Widget _teamAddress(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: Text(
          stadiumAddress + ", " + stadiumCity + " - " + teamCountry,
          style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buttonRow(){
    return Row(
      children: [
        _displayStatsButton(),
        _displaySquadButton(),
      ],
    );
  }

  Widget _displayStatsButton() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20, right: 20, left: 30),
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TeamStatisticsPage(
                      leagueName, leagueLogo, selectedTeamId, leagueId,
                      selectedTeamName, selectedTeamLogo
                  )
                  )
              );
            },
            child: const Text(
                "Statistics"
            ),
          ),
        )
    );
  }

  Widget _displaySquadButton() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    SquadPage(selectedTeamId, selectedTeamName, selectedTeamLogo)
                )
              );
            },
            child: const Text(
              "Current Squad"
            ),
          ),
        )
    );
  }

}