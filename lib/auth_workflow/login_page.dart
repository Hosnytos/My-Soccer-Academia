import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_soccer_academia/auth_workflow/auth_service.dart';
import 'package:my_soccer_academia/auth_workflow/register_page.dart';
import 'package:my_soccer_academia/pages/bottom_navigation.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart';
import 'package:my_soccer_academia/utils/pop_up_message.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strm;

class LoginPage extends StatefulWidget {
  LoginPage(this.client, this.channel);
  strm.StreamChatClient client;
  strm.Channel channel;

  @override
  _LoginPageState createState() => _LoginPageState(
    client:this.client,
    channel:this.channel,
  );
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({
    required this.client,
    required this.channel
  });
  strm.StreamChatClient client;
  strm.Channel channel;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late String loginTF = "";
  late String pwdTF = "";
  bool _isHidden = true;
  final google = GoogleSignIn();
  GoogleSignInAccount ? userGoogle;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MSAColors.lightWhite,
      body: _pageBody(authService),
    );
  }

  Widget _pageBody(authService){
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _msaLogo(),
            _emailField(),
            _pwdField(),
            _loginButton(authService),
            _googleAuth(),
            _noAccount()
          ],
      ),
      ),
    );
  }

  Widget _msaLogo(){
    return Container(
        margin: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width / 1.5,
        height: 125,
        child: Image.asset(
            'assets/msa_logo.png')
    );
  }

  Widget _emailField(){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        )
      ),
        height: 59,
        margin: const EdgeInsets.only(top: 30 ,bottom: 20.0, right: 43, left: 43),
        child: TextFormField(
            onChanged: (String string) {
              loginTF = string;
            },
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: BorderSide(color: MSAColors.lightWhite, width: 0.0),
                ),
                prefixIcon: const Icon(Icons.person,
                color: Colors.green,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    )
                ),
                labelText: "Username",
                labelStyle: GoogleFonts.rajdhani(
            textStyle: const TextStyle(
            color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
        ),
            )
        )
    );
  }

  Widget _pwdField(){
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            )
        ),
        height: 59,
        margin: const EdgeInsets.only(top: 10 ,bottom: 20.0, right: 43, left: 43),
        child: TextField(
            onChanged: (String string) {
              pwdTF = string;
            },
            onSubmitted: (String string) {
              pwdTF = string;
            },
            obscureText: _isHidden,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: BorderSide(color: MSAColors.lightWhite, width: 0.0),
                ),
                prefixIcon: const Icon(Icons.lock,
                  color: Colors.green,
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    )
                ),
                suffix: InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(
                    _isHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.green,
                  ),
                ),
                labelText: "Password",
                labelStyle: GoogleFonts.rajdhani(
                  textStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            )
        )
    );
  }

  Widget _loginButton(authService){
    return Container(
      height: 45,
        width: 180,
        margin: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 29.5, vertical: 11),
            ),
            onPressed: () async {
                 await authService.signWithEmailAndPassword(loginTF, pwdTF);
                 var currentUser = FirebaseAuth.instance.currentUser;
                 if(currentUser != null) {
                   final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                   strm.StreamChatCore.of(context).client.disconnectUser();
                   var userToken = strm.StreamChatCore.of(context).client.devToken("$currentUserId").toString();
                   userToken = userToken.split(' ')[1].toString();
                   userToken = userToken.split(',')[0];
                   strm.StreamChatCore.of(context).client.connectUser(strm.User(id: "$currentUserId"),
                       userToken
                   );
                   channel.addMembers(["$currentUserId"]);
                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                       builder: (context) => BottomNavigation(client, channel)));
                 }
                 else {
                   PopUpMessage().SnackError(
                       "Credentials error !!!",
                       _scaffoldKey);
                 }
            },
            child: Text(
                "LOGIN",
              style: GoogleFonts.rajdhani(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _googleAuth(){
    return Container(
        height: 40.0,
        margin: const EdgeInsets.only(top: 25, right: 43, left: 43),
            child: InkWell(
                onTap: () async {
                  try{
                    final googleMethod = await google.signIn();
                    userGoogle = googleMethod;
                    final authGoogle = await googleMethod!.authentication;
                    final credGoogle = GoogleAuthProvider.credential(
                        accessToken: authGoogle.idToken,
                        idToken: authGoogle.idToken
                    );
                    await FirebaseAuth.instance.signInWithCredential(credGoogle);
                    var currentUser = FirebaseAuth.instance.currentUser?.uid;
                    if(currentUser != null) {
                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                      strm.StreamChatCore.of(context).client.disconnectUser();
                      var userToken = strm.StreamChatCore.of(context).client.devToken("$currentUserId").toString();
                      userToken = userToken.split(' ')[1].toString();
                      userToken = userToken.split(',')[0];
                      strm.StreamChatCore.of(context).client.connectUser(strm.User(id: "$currentUserId"),
                          userToken
                      );
                      channel.addMembers(["$currentUserId"]);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) =>
                              BottomNavigation(client, channel)
                          )
                      );
                    }
                    else {
                      PopUpMessage().SnackError(
                          "Credentials error !!!",
                          _scaffoldKey);
                    }
                  }
                  catch(e){
                    print(e);
                  }
                },
                child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 60,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0))
                              ),
                              child: Image.asset(
                                "assets/google_logo.png",
                                width: 25,
                              )
                          ),
                          Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0))),
                              child: Text(
                                  "Login with your Google account",
                                style: GoogleFonts.rajdhani(
                                  textStyle: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          )
                        ])
                )
            )
        );
  }

  Widget _noAccount(){
    return Container(
        margin: const EdgeInsets.only(top: 30.0),
        child: RichText(
            text: TextSpan(
              style: GoogleFonts.rajdhani(
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                ),
              text: "Don't have an account ?",
              children: <TextSpan>[
                const TextSpan(text: " "),
                TextSpan(
                    text: "Register",
                    style: GoogleFonts.rajdhani(
                      textStyle: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                RegisterPage(client, channel)
                            )
                        );
                      })
              ],
            )
        )
    );
  }

  bool isEmailRegValid(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  bool checkFieldsValues() {
    if (loginTF.isEmpty || pwdTF.isEmpty) {
      return false;
    }
    return true;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

}
