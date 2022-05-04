import 'package:flutter/material.dart';
import 'package:my_soccer_academia/auth_workflow/auth_service.dart';
import 'package:my_soccer_academia/auth_workflow/login_page.dart';
import 'package:my_soccer_academia/models/user_model.dart';
import 'package:my_soccer_academia/pages/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Wrapper extends StatefulWidget {
  Wrapper(this.client, this.channel);
  StreamChatClient client;
  Channel channel;

  @override
  _Wrapper createState() {
    return _Wrapper(
      client:this.client,
      channel:this.channel,
    );
  }
}

class _Wrapper extends State<Wrapper> {
  _Wrapper({
    required this.client,
    required this.channel
  });
  StreamChatClient client;
  Channel channel;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<UserModel?> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          final UserModel? user = snapshot.data;
          return user == null ? LoginPage(client, channel) : BottomNavigation(client, channel);
        }
        else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}