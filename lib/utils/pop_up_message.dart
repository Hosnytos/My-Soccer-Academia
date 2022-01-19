import 'package:flutter/material.dart';

class PopUpMessage {

  void SnackError(String message, GlobalKey<ScaffoldState> scaffoldKey) {
    SnackBar snackBar = new SnackBar(
      content: new Text(
        message,
        style: new TextStyle(
            color: Colors.white
        ),
      ),
      backgroundColor: Colors.red,
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  void SnackMessage(String message, GlobalKey<ScaffoldState> scaffoldKey) {
    SnackBar snackBar = new SnackBar(
      content: new Text(
        message,
        style: new TextStyle(
            color: Colors.white
        ),
      ),
      backgroundColor: Colors.green,
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}