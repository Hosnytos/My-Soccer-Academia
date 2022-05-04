import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/player_statistics_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

class PlayerDetailsPage extends StatefulWidget {

  PlayerDetailsPage(this.selectedPlayerId, this.selectedPlayerName,
  this.selectedTeamName, this.selectedTeamLogo, this.selectedPlayerPosition,
      this.selectedPlayerNumber);

  int selectedPlayerId = 0;
  String selectedPlayerName = "";
  String selectedTeamName = "";
  String selectedTeamLogo = "";
  String selectedPlayerPosition = "";
  int selectedPlayerNumber = 0;

  @override
  _PlayerDetailsPageState createState() => _PlayerDetailsPageState(
    selectedPlayerId:this.selectedPlayerId,
      selectedPlayerName:this.selectedPlayerName,
      selectedTeamName:this.selectedTeamName,
      selectedTeamLogo:this.selectedTeamLogo,
      selectedPlayerPosition:this.selectedPlayerPosition,
      selectedPlayerNumber:this.selectedPlayerNumber
  );
}

class _PlayerDetailsPageState extends State<PlayerDetailsPage> {

  _PlayerDetailsPageState({
    required this.selectedPlayerId,
    required this.selectedPlayerName,
    required this.selectedTeamName,
    required this.selectedTeamLogo,
    required this.selectedPlayerPosition,
    required this.selectedPlayerNumber
  });

  int selectedPlayerId = 0;
  String selectedPlayerName = "";
  String selectedTeamName = "";
  String selectedTeamLogo = "";
  String selectedPlayerPosition = "";
  int selectedPlayerNumber = 0;

  String playerPicture = "";
  String playerFirstName = "";
  String playerLastName = "";
  int playerNumber = 0;
  int playerAge = 0;
  String playerHeight = "";
  String playerWeight = "";
  String playerNationality = "";


  @override
  void initState() {
    super.initState();
    getPlayerInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlayerName,
          style: const TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }

  void getPlayerInfo() async{
    var myPlayerInfo = await fetchGetDataList(
        RequestType.get,
        '/v3/players',
        {
          "id": "$selectedPlayerId",
          "season": "2021"
        });

    setState(() {
      var myPlayerBody = myPlayerInfo.body[0]['player'];
      if(selectedPlayerId == 276){
        playerPicture = 'https://media.contentapi.ea.com/content/dam/ea/fifa/fifa-22/news/common/ratings-reveal/best-dribblers/neymar-jr.png.adapt.crop16x9.652w.png';
      }
      else if(selectedPlayerId == 278){
        playerPicture = 'https://media.contentapi.ea.com/content/dam/ea/fifa/fifa-22/news/common/ratings-reveal/career-mode-highest-potential/kylian-mbappe.png.adapt.crop16x9.652w.png';
      }
      else if(selectedPlayerId == 874){
        playerPicture = 'https://media.contentapi.ea.com/content/dam/ea/fifa/fifa-22/news/common/ratings-reveal/ratings-reveal-premier-league/cristiano-ronaldo.png.adapt.crop16x9.652w.png';
      }
      else if(selectedPlayerId == 154){
        playerPicture = 'https://media.contentapi.ea.com/content/dam/ea/fifa/fifa-22/news/common/ratings-reveal/best-dribblers/lionel-messi.png.adapt.crop16x9.652w.png';
      }
      else{
        playerPicture = myPlayerBody['photo'].toString();
      }
      playerFirstName = myPlayerBody['firstname'].toString();
      playerLastName = myPlayerBody['lastname'].toString();
      playerAge = myPlayerBody['age'];
      playerHeight = myPlayerBody['height'].toString();
      playerWeight = myPlayerBody['weight'].toString();
      playerNationality = myPlayerBody['nationality'].toString();
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
                _playerInfo(),
                _largeDivider(),
                _rowName(),
                _rowTeamInfo(),
                _rowGeneralInfo(),
                _rowPhysics(),
                _rowCountry(),
                _buttonRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _playerPicture(){

    return Container(
      width: 210.0,
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

  Widget _playerInfo(){
    return const Padding(
      padding: EdgeInsets.only(top : 18, bottom : 18),
      child: Text(
        "Player Info",
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

  Widget _rowName(){
    return Row(
      children: [
        _playerNumber(),
        _columnFullName()
      ],
    );
  }

  Widget _playerNumber(){
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 22.0),
      child: Text("$selectedPlayerNumber",
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 70.0,
        ),
      ),
    );
  }

  Widget _columnFullName(){
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _playerFirstName(),
          _playerLastName()
        ],
      ),
    );
  }

  Widget _playerFirstName(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(playerFirstName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _playerLastName(){
    return Text(playerLastName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      );
  }

  Widget _rowTeamInfo(){
    return Row(
        children: [
          _teamLogo(),
          _playerTeamName()
        ],
      );
  }

  Widget _teamLogo(){
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20.0),
      child: Container(
        width: 35.0,
        height: 35.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(0.0)),
          image: DecorationImage(
              image: NetworkImageWithRetry(
                  selectedTeamLogo),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _playerTeamName(){
    return Text(selectedTeamName,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15.0,
      ),
    );
  }

  Widget _rowGeneralInfo(){
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: [
          _playerAge(),
          _playerPosition()
        ],
      ),
    );
  }

  Widget _playerAge(){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 90.0),
      child: Text("Age : $playerAge",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _playerPosition(){
    return Text("Position : " + selectedPlayerPosition,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
        );
  }

  Widget _rowPhysics(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          _playerHeight(),
          _playerWeight()
        ],
      ),
    );
  }

  Widget _playerHeight(){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 41.0),
      child: Text("Height : " + playerHeight,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _playerWeight(){
    return Text("Weight : " + playerWeight,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      );
  }

  Widget _rowCountry(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          _playerCountry(),
        ],
      ),
    );
  }

  Widget _playerCountry(){
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 41.0),
      child: Text("Nationality : " + playerNationality,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _buttonRow(){
    return Row(
      children: [
        _displayStatsButton(),
      ],
    );
  }

  Widget _displayStatsButton() {
    return Container(
        margin: const EdgeInsets.only(top: 30.0, bottom: 20, right: 20, left: 75),
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
                  MaterialPageRoute(builder: (context) => PlayerStatisticsPage(
                    selectedPlayerId, selectedPlayerName, playerPicture,

                  )
                  )
              );
            },
            child: const Text(
                "Season 2021 Statistics"
            ),
          ),
        )
    );
  }

}