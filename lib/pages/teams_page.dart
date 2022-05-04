import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/team_details_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

class TeamsPage extends StatefulWidget {

  TeamsPage(this.leagueId, this.leagueName, this.leagueLogo);

  int leagueId = 0;
  String leagueName = "";
  String leagueLogo = "";

  @override
  _TeamsPageState createState() => _TeamsPageState(
    leagueId:this.leagueId,
      leagueName:this.leagueName,
      leagueLogo:this.leagueLogo
  );
}

class _TeamsPageState extends State<TeamsPage> {

  _TeamsPageState({required this.leagueId, required this.leagueName,
    required this.leagueLogo
  });

  int leagueId = 0;
  String leagueName = "";
  String leagueLogo = "";

  List<String> teamNameList = [];
  List<String> teamLogoList = [];
  List<int> teamIdList = [];

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(leagueName, style: const TextStyle(fontSize: 25),),
          centerTitle: true,
      ),
      body: _teamsGridView(),
          );
  }

  void getTeams() async{
    var allTeams = await fetchGetDataList(
        RequestType.get,
        '/v3/teams',
        {
          "league": "$leagueId",
          "season": "2021"
        });

    setState(() {
      var allTeamsBody = allTeams.body;
      for(int i = 0; i< allTeamsBody.length; i++){
        teamNameList.add(allTeamsBody[i]['team']['name']);
        teamLogoList.add(allTeamsBody[i]['team']['logo']);
        teamIdList.add(allTeamsBody[i]['team']['id']);
      }

    });
  }

  Widget _teamsGridView(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: teamNameList.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                    children: [
                      _teamLogo(index),
                      _teamName(index)
                    ]
                ),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
              );
            }),
      );
  }

  Widget _teamName(index){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
          teamNameList[index]
      ),
    );
  }

  Widget _teamLogo(index){
    int selectedTeamId = teamIdList[index];
    String selectedTeamName = teamNameList[index];
    String selectedTeamLogo = teamLogoList[index];

    return Padding(
      padding:
      const EdgeInsets.only(top: 20, bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                TeamDetailsPage(selectedTeamId)
            )
        ),
        child: Container(
          width: 55.0,
          height: 75.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(12.0)),
            image: DecorationImage(
                image: NetworkImageWithRetry(
                    teamLogoList[index]),
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

}