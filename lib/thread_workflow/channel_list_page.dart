import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_soccer_academia/thread_workflow/channel_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}