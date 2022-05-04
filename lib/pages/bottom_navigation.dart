import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_soccer_academia/auth_workflow/user_profile.dart';
import 'package:my_soccer_academia/pages/home_screen.dart';
import 'package:my_soccer_academia/pages/standings.dart';
import 'package:my_soccer_academia/thread_workflow/thread_page.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';


class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.client, this.channel);
  StreamChatClient client;
  Channel channel;

  @override
  _BottomNavigationState createState() => _BottomNavigationState(
    client:this.client,
    channel:this.channel,
  );
}

class _BottomNavigationState extends State<BottomNavigation> {
  _BottomNavigationState({
    required this.client,
    required this.channel
  });
  StreamChatClient client;
  Channel channel;

  int _seletedItem = 0;
  List<Widget> _pages() => [
    homeScreen(),
    standings(),
    MyThread(client: client,channel: channel),
    UserProfile(client, channel)
  ];
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> navPages = _pages();
    return Scaffold(
      body: PageView(
        children: navPages,
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GoogleFonts.rajdhani(),
        selectedFontSize: 16,
        unselectedLabelStyle: GoogleFonts.rajdhani(),
        type: BottomNavigationBarType.fixed,
        backgroundColor: MSAColors.bottomNavBar,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Standings',),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined), label: 'Thread'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _seletedItem,
        onTap: (index) {
          setState(() {
            _seletedItem = index;
            _pageController.animateToPage(_seletedItem,
                duration: const Duration(milliseconds: 100), curve: Curves.linear);
          });
        },
      ),
    );
  }

}