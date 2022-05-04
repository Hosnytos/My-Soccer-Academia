import 'package:flutter/material.dart';
import 'package:my_soccer_academia/auth_workflow/wrapper.dart';
import 'dart:async';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen(this.client, this.channel);
  StreamChatClient client;
  Channel channel;

  @override
  _SplashScreen createState() {
    return _SplashScreen(
      client:this.client,
      channel:this.channel,
    );
  }
}

class _SplashScreen extends State<SplashScreen> {
  _SplashScreen({
    required this.client,
    required this.channel
  });
  StreamChatClient client;
  Channel channel;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>
                Wrapper(client, channel)
            )
        )
    );
    opacityDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
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