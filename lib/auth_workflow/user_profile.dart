import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'auth_service.dart';
import 'login_page.dart';

class UserProfile extends StatefulWidget {
  UserProfile(this.client, this.channel);
  StreamChatClient client;
  Channel channel;

  @override
  _UserProfileState createState() => _UserProfileState(
    client:this.client,
    channel:this.channel,
  );
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState({
    required this.client,
    required this.channel
  });
  StreamChatClient client;
  Channel channel;

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    String? currentUserName;
    String? playerPicture;
    var accountCreationTimeWK = currentUser?.metadata.creationTime?.weekday;
    String? weekDay;
    for(int i=0; i<7; i++){
      if(accountCreationTimeWK == 1){
        weekDay = "Monday";
      }
      else if(accountCreationTimeWK == 2){
        weekDay = "Tuesday";
      }
      else if(accountCreationTimeWK == 3){
        weekDay = "Wednesday";
      }
      else if(accountCreationTimeWK == 4){
        weekDay = "Thursday";
      }
      else if(accountCreationTimeWK == 5){
        weekDay = "Friday";
      }
      else if(accountCreationTimeWK == 6){
        weekDay = "Saturday";
      }
      else if(accountCreationTimeWK == 7){
        weekDay = "Sunday";
      }
      else{
        weekDay = "";
      }
    }
    var accountCreationTimeDay = currentUser?.metadata.creationTime?.day;
    var accountCreationTimeMonth = currentUser?.metadata.creationTime?.month;
    var accountCreationTimeYear = currentUser?.metadata.creationTime?.year;
    var accountInfo = "$weekDay $accountCreationTimeDay/$accountCreationTimeMonth/$accountCreationTimeYear";
    if(currentUser?.displayName == null){
      currentUserName = currentUser?.email;
    }
    else {
      currentUserName = currentUser?.displayName;
    }
    if(currentUser?.photoURL == null){
      playerPicture = "http://www.clker.com/cliparts/u/t/7/t/G/z/white-soccer-player-hi.png";
    }
    else {
      playerPicture = currentUser?.photoURL;
    }
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: MSAColors.bottomNavBar,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: _userBody(playerPicture, currentUserName, authService, accountInfo)
    );
  }

  Widget _userBody(playerPicture, currentUserName, authService, accountInfo){
    return Center(
      child: Column(
        children: [
          _userPicture(playerPicture),
          _userName(currentUserName),
          _userCreated(accountInfo),
          _largeDivider(),
          _signOutButton(authService)
        ],
      ),
    );
  }
  
  Widget _userPicture(playerPicture){
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, bottom: 48.0),
      child: Container(
        width: 210.0,
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(60.0)),
          image: DecorationImage(
              image: NetworkImageWithRetry(
                  playerPicture),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _userName(currentUserName){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "User : $currentUserName",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _userCreated(accountInfo){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Created : $accountInfo",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.0,
        ),
      ),
    );
  }

  Widget _largeDivider() {
    return const Padding(
      padding: EdgeInsets.only(top: 18.0, bottom: 8.0),
      child: Divider(
        color: Colors.grey,
        thickness: 0.5,
        height: 5,
        indent: 45,
        endIndent: 45,
      ),
    );
  }

  Widget _signOutButton(authService) {
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
            onPressed: () async {
              await authService.signOut();
              await GoogleSignIn().signOut();
              StreamChatCore.of(context).client.disconnectUser();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage(client, channel)
                  )
              );
            },
            child: const Text(
                "Signout"
            ),
          ),
        )
    );
  }

}