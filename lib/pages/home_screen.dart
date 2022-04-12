import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_soccer_academia/utils/msa_colors.dart' as msa_color;

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.grey[850],
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  height: 58,
                  margin: const EdgeInsets.only(left: 28.8, top: 28.8, right: 28.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.6),
                          color: Colors.yellow,
                        ),
                        child: const Icon(
                          Icons.horizontal_split_outlined,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.6),
                          color: Colors.blue,
                        ),
                        child: const Icon(
                          Icons.search_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                //-------- Leagues Section ------------------
                Container(
                  margin: EdgeInsets.only(top: 45, left: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
                    color: msa_color.MSAColors.darkGrey,
                  ),
                  height: 200,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: PageController(),

                  ),


                )
              ],
            ),
          )),
    );
  }
}