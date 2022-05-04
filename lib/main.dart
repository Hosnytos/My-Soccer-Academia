import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_soccer_academia/auth_workflow/auth_service.dart';
import 'package:my_soccer_academia/auth_workflow/wrapper.dart';
import 'package:my_soccer_academia/pages/searchDelegate.dart';
import 'package:my_soccer_academia/pages/splash_screen.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/pages/teams_page.dart';
import 'package:my_soccer_academia/rest/request.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strm;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final client = strm.StreamChatClient(
      'tbnvcrvbc6me',
      logLevel: strm.Level.INFO
  );
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  await client.connectUser(strm.User(id: '$currentUserId'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.bcURzRxLZZk2uLhOoet1GiPaVHX3rbFcno8EnBi1e1w'
  );
  final channel = client.channel('messaging',id: 'Main-Channel');
  channel.watch();
  runApp(MyApp(client: client, channel: channel));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,required this.client, required this.channel}) : super(key: key);
  final strm.StreamChatClient client;
  final strm.Channel channel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: MSAColors.bottomNavBar,
              secondary: MSAColors.bottomNavBar,
            )
        ),
        builder: (context, child){
          return strm.StreamChatCore(
            client: client,
            child: strm.StreamChat(
                client: client,
                child: child
            ),
          );
        },
        home: SplashScreen(client, channel),
      )
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
  String leagueName = "";
  String leagueLogo = "";
  int leagueId = 0;

  List<String> leagueNameList = [];
  List<String> leagueLogoList = [];
  List<int> leagueIdList = [];
  List<int> listFavLeague = [39, 78, 140, 61, 135, 424];

  @override
  void initState() {
    super.initState();
    getLeague();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/msa_logo.png",
          height: 35,
          width: 45,
        ),
        centerTitle: true,
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
        backgroundColor: MSAColors.bottomNavBar,
        elevation: 0,
      ),
      body: _bodyContainer(),
    );
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

  Widget _bodyContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _leagues(),
        Expanded(child: _listView()),
        _fixtures(),
      ],
    );
  }

  Widget _leagues() {
    return const Padding(
      padding: EdgeInsets.only(top: 18.0, right: 250, bottom: 18),
      child: Center(
        child: Text(
          "League",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _fixtures() {
    return const Padding(
      padding: EdgeInsets.only(top: 25.0, right: 250, bottom: 18),
      child: Center(
        child: Text(
          "Fixtures",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: leagueNameList.length,
        itemBuilder: (context, index) {
          return _pageBody(index);
        });
  }

  Widget _pageBody(index) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: _cardBody(index));
  }

  Widget _cardBody(index) {
    leagueId = leagueIdList[index];
    leagueName = leagueNameList[index];
    leagueLogo = leagueLogoList[index];

    return SizedBox(
      width: 70,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TeamsPage(leagueIdList[index],
                leagueNameList[index], leagueLogoList[index]))),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 7.5,
          child: Column(
            children: [
              _leagueLogo(index),
              // _leagueTitle(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leagueLogo(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          image: DecorationImage(
              image: NetworkImageWithRetry(leagueLogoList[index]),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _leagueTitle(index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 10),
      child: Center(
        child: Text(
          leagueNameList[index],
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }
}
