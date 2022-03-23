import 'package:flutter/material.dart';
import 'package:my_soccer_academia/auth_workflow/auth_service.dart';
import 'package:my_soccer_academia/auth_workflow/login_page.dart';
import 'package:my_soccer_academia/main.dart';
import 'package:my_soccer_academia/models/user_model.dart';
import 'package:my_soccer_academia/pages/beta_main_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<UserModel?> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          final UserModel? user = snapshot.data;
          return user == null ? LoginPage() : const BetaMainPage();
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