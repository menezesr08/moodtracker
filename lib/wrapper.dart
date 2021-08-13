import 'package:flutter/material.dart';
import 'package:how_are_you/models/user.dart';
import 'package:how_are_you/screens/home.dart';
import 'package:how_are_you/screens/login.dart';
import 'package:provider/provider.dart';

// This class listens to the auth stream and decides whether to show
// Login screen or the Home page
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the StandardUser stream
    final user = Provider.of<StandardUser?>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return Home();
    }
  }
}
