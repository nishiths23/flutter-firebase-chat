import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_sdk/flutter_firebase_chat_sdk.dart';
import 'package:flutter_firebase_chat_sdk/flutter_firebase_observable_app.dart';

import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterFirebaseChatSDK.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlutterFirebaseObservableApp(
        child: FlutterFirebaseChatSDK.instance.isUserLoggedIn ? Home() : Login(),
      ),
    );
  }
}
