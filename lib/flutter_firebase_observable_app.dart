/**
 * created by Nishith on 26/09/20.
 */

import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_sdk/flutter_firebase_chat_sdk.dart';

class FlutterFirebaseObservableApp extends StatefulWidget {
  const FlutterFirebaseObservableApp({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  State<StatefulWidget> createState() => _FlutterFirebaseObservableAppState(child);
}

class _FlutterFirebaseObservableAppState extends State<FlutterFirebaseObservableApp> with WidgetsBindingObserver {
  _FlutterFirebaseObservableAppState(this.child);
  final Widget child;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    FlutterFirebaseChatSDK.instance.updateState(state);
  }

  @override
  Widget build(BuildContext context) => child;
}
