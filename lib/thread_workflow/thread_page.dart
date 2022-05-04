import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/auth_workflow/auth_service.dart';
import 'package:my_soccer_academia/thread_workflow/channel_list_page.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strm;

class MyThread extends StatelessWidget {
  const MyThread({Key? key,required this.client, required this.channel}) : super(key: key);
  final strm.StreamChatClient client;
  final strm.Channel channel;


  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.from(
      colorScheme: const ColorScheme.dark()
    );

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
            primarySwatch: Colors.green,
          ),
          builder: (context, child){
            return strm.StreamChat(
                streamChatThemeData: strm.StreamChatThemeData.fromTheme(theme),
                client: client,
                child: child
            );
          },
          home: strm.StreamChannel(
            channel: channel,
            child: ChannelListPage(),
          ),
        )
    );
  }
}