import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_soccer_academia/pages/beta_main_page.dart';
import 'package:my_soccer_academia/pages/splash_screen.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/teams_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MySoccerApp extends StatelessWidget {
  const MySoccerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //home: const MyHomePage(title: 'My Soccer Academia'),
      home: BetaMainPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String leagueName ="";
  String leagueLogo ="";
  int leagueId = 0;

  List<String> leagueNameList = [];
  List<String> leagueLogoList = [];
  List<int> leagueIdList = [];

  @override
  void initState() {
    super.initState();
    getLeague();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _listView(),
    );
  }

  void getLeague() async{

    var leagueFetch = await fetchGetDataList(
        RequestType.get,
        '/v3/leagues',
        {"": ""});

    setState(() {
      for(int i = 0; i <leagueFetch.body.length; i++ ){
        var leagueBodyId = leagueFetch.body[i]['league']['id'];
        if(leagueBodyId == 39 || leagueBodyId == 78 || leagueBodyId == 140 ||
            leagueBodyId == 61 || leagueBodyId == 135 || leagueBodyId == 424){

          leagueNameList.add(leagueFetch.body[i]['league']['name']);
          leagueLogoList.add(leagueFetch.body[i]['league']['logo']);
          leagueIdList.add(leagueFetch.body[i]['league']['id']);
        }
      }
    });
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: leagueNameList.length,
        itemBuilder: (context, index){
          return _pageBody(index);
        });
  }

  Widget _pageBody(index){
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: _cardBody(index)
    );
  }

  Widget _cardBody(index){
    leagueId = leagueIdList[index];
    leagueName = leagueNameList[index];
    leagueLogo = leagueLogoList[index];

    return SizedBox(
      height: 250,
      width: 500,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TeamsPage(leagueIdList[index],
                leagueNameList[index],
                leagueLogoList[index])
            )
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          elevation: 7.5,
          child: Column(
            children: [
              _leagueLogo(index),
              _leagueTitle(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leagueLogo(index){
    return Padding(
      padding:
      const EdgeInsets.only(top: 10, left: 12),
      child: Container(
        width: 100.0,
        height: 155.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(12.0)),
          image: DecorationImage(
              image: NetworkImageWithRetry(
                  leagueLogoList[index]),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _leagueTitle(index){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Center(
        child: Text(
          leagueNameList[index],
          style: const TextStyle(
              color: Colors.black, fontSize: 17),
        ),
      ),
    );
  }

}
