import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/user.dart';
import 'package:how_are_you/services/auth.dart';
import 'package:how_are_you/wrapper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // StreamProvider listens to our AuthService stream for firebase auth changes.
    // Stream provider then passes these changes to the wrapper widget.
    return StreamProvider<StandardUser?>.value(
      catchError: (_,__) => null,
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
