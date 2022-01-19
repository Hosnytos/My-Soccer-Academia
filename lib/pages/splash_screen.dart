import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../main.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>
            const MySoccerApp()
            )
        )
    );
    opacityDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _expanded()
            ],
          )
        ],
      ),
    );
  }

  Widget _expanded(){
    return Expanded(
        flex: 1,
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _msaLogo(),
                _msaName()
              ],
            )));
  }

  Widget _msaLogo(){
    return Container(
        margin: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width / 1.5,
        height: 100,
        child: Image.asset(
            'assets/msa_logo.png', height: 200)
    );
  }

  Widget _msaName(){
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: const Text(
          "MSA\n My Soccer Academia",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Future opacityDelay() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        visible = true;
      });
    });
  }
}