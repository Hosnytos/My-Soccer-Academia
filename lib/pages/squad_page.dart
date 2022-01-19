import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/player_details_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

class SquadPage extends StatefulWidget {

  SquadPage(this.selectedTeamId, this.selectedTeamName, this.selectedTeamLogo);

  int selectedTeamId = 0;
  String selectedTeamName = "";
  String selectedTeamLogo = "";

  @override
  _SquadPageState createState() => _SquadPageState(
    selectedTeamId:this.selectedTeamId,
      selectedTeamName:this.selectedTeamName,
      selectedTeamLogo:this.selectedTeamLogo
  );
}

class _SquadPageState extends State<SquadPage> {

  _SquadPageState({
    required this.selectedTeamId,
    required this.selectedTeamName,
    required this.selectedTeamLogo
  });

  int selectedTeamId = 0;
  String selectedTeamName = "";
  String selectedTeamLogo = "";
  List<String> playerNameList = [];
  List<String> playerPictureList = [];
  List<String> playerPositionList = [];
  List<int> playerNumberList = [];
  List<int> playerIdList = [];

  @override
  void initState() {
    super.initState();
    getSquadInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Season 2021 Squad", style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: getBody(),
    );
  }

  void getSquadInfo() async{
    var mySquadInfo = await fetchGetDataList(
        RequestType.get,
        '/v3/players/squads',
        {
          "team": "$selectedTeamId"
        });

    setState(() {
      var mySquadBody = mySquadInfo.body[0];
      var listLength = mySquadInfo.body[0]['players'];
      for(int i = 0; i< listLength.length; i++){
        playerNameList.add(mySquadBody['players'][i]['name']);
        playerPictureList.add(mySquadBody['players'][i]['photo']);
        playerPositionList.add(mySquadBody['players'][i]['position']);
        playerIdList.add(mySquadBody['players'][i]['id']);
        if(mySquadBody['players'][i]['number'] == null){
          playerNumberList.add(99);
        }
        else{
          playerNumberList.add(mySquadBody['players'][i]['number']);
        }
      }
    });
  }

  Widget getBody(){
    return ListView.builder(
        itemCount: playerNameList.length,
        itemBuilder: (context, index){
          return _pageBody(index);
        });
  }

  Widget _pageBody(index){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: bodyCard(index)
    );
  }

  Widget bodyCard(index){
    int selectedPlayerId = playerIdList[index];
    String selectedPlayerName = playerNameList[index];
    String selectedPlayerPosition = playerPositionList[index];
    int selectedPlayerNumber = playerNumberList[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListTile(
          title: Row(
              children: <Widget>[
                const SizedBox(height: 20,),
                playerPicture(index),
                const SizedBox(height: 20, width: 25,),
                columnPlayerInfo(index)
              ]
          ),

          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    PlayerDetailsPage(selectedPlayerId, selectedPlayerName,
                    selectedTeamName, selectedTeamLogo, selectedPlayerPosition,
                        selectedPlayerNumber)
                )
            );
          },
        ),
      ),
    );
  }

  Widget playerPicture(index){
    return Container(
      alignment: Alignment.centerLeft,
      height: 70,
      width: 70,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(60.0)),
          color: Colors.black12,
          image: DecorationImage(
              fit: BoxFit.fill,
              image:
              NetworkImageWithRetry(playerPictureList[index])
          )
      ),
    );
  }

  Widget columnPlayerInfo(index){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          playerName(index),
          constSizedBox(),
          playerPosition(index),
          constSizedBox(),
          playerNumber(index)
        ]
    );
  }

  Widget constSizedBox(){
    return const SizedBox(height: 10);
  }

  Widget playerName(index){
    return SizedBox(width: MediaQuery.of(context).size.width*0.3,
        child:
        Text(playerNameList[index],
          style: const TextStyle(fontSize: 17,
            color: Colors.black,
            decorationStyle: TextDecorationStyle.wavy,)
          ,)
    );
  }

  Widget playerPosition(index){
    return SizedBox(width: 115,
        child: Text("Position : " + playerPositionList[index],
          style: const TextStyle(fontSize: 12,
            color: Colors.black,),
        )
    );
  }

  Widget playerNumber(index){
    int selectedPlayerNumber = playerNumberList[index];

    return Text("N° : $selectedPlayerNumber",
      style: const TextStyle(fontSize: 12, color: Colors.black,),
    );
  }

}