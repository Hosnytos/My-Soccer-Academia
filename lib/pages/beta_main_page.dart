import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:my_soccer_academia/auth_workflow/login_page.dart';
import 'package:my_soccer_academia/auth_workflow/register_page.dart';
import 'package:my_soccer_academia/rest/request.dart';

import '../main.dart';

class BetaMainPage extends StatefulWidget {
  const BetaMainPage({Key? key}) : super(key: key);



  @override
  _BetaMainPageState createState() => _BetaMainPageState(

  );
}

class _BetaMainPageState extends State<BetaMainPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Page test", style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: _multiX(),
    );
  }

  Widget _multiX(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _displayLeaguesButton(),
          _displayLiveScoreButton(),
          _displayLoginButton(),
          _displayRegisterButton()
        ],
      ),
    );
  }

  Widget _displayLeaguesButton() {
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
              primary: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      const MyHomePage(title: 'My Soccer Academia')
                  )
              );
            },
            child: const Text(
                "Display Leagues"
            ),
          ),
        )
    );
  }

  Widget _displayLiveScoreButton() {
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
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {

            },
            child: const Text(
                "Display Live Score"
            ),
          ),
        )
    );
  }

  Widget _displayLoginButton() {
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
              primary: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                  LoginPage()
                  )
              );
            },
            child: const Text(
                "Display Login Page"
            ),
          ),
        )
    );
  }

  Widget _displayRegisterButton() {
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
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      RegisterPage()
                  )
              );
            },
            child: const Text(
                "Display Register Page"
            ),
          ),
        )
    );
  }
}