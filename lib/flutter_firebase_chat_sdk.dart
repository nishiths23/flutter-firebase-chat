library flutter_firebase_chat_sdk;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_chat_sdk/chat/group.dart';

class FlutterFirebaseChatSDK {
  ///
  /// Returns boolean value representing if a user is already logged in or not
  ///
  bool get isUserLoggedIn => FirebaseAuth.instance.currentUser != null;

  ///
  /// Returns user id if the user is logged in or null
  ///
  String get userId => FirebaseAuth.instance.currentUser?.uid;

  ///
  /// Initialize SDK
  ///
  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
    return null;
  }

  ///
  /// Observable list of groups
  ///
  ValueNotifier<List<Group>> get groups => _groups;

  ///
  /// Observable map of groups id to group name
  ///
  ValueNotifier<Map<String, String>> get groupToNameMap => _groupToNameMap;

  void updateState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser.uid + "/status/").set("online");
    } else {
      FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser.uid + "/status/").set("offline");
    }
  }

  ValueNotifier<List<Group>> _groups = ValueNotifier(null);
  ValueNotifier<Map<String, String>> _groupToNameMap = ValueNotifier(null);

  FlutterFirebaseChatSDK._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        _makeUserOnline();
        _saveDeviceToken();
        FirebaseFirestore.instance
            .collectionGroup('Channels')
            .where('members', arrayContains: FirebaseAuth.instance.currentUser.uid)
            .snapshots()
            .listen((event) => _groups.value = event.docs.asMap().values.map((e) => Group.fromJson(e.data())).toList());
        FirebaseFirestore.instance.collection('Users/${FirebaseAuth.instance.currentUser.uid}/friends').snapshots().listen(
            (event) => _groupToNameMap.value = Map<String, String>.fromIterable(event.docs, key: (v) => v.data()['groupId'], value: (e) => e.data()['name']));
      }
    });
  }

  Future<void> _saveDeviceToken() async {
    if (userId != null) {
      final token = await _fcm.getToken();
      // await FirebaseFirestore.instance.doc('Users/${FirebaseAuth.instance.currentUser.uid}').set({'notificationId': token}, SetOptions(merge: true));
      await FirebaseDatabase.instance
          .reference()
          .child(FirebaseAuth.instance.currentUser.uid + '/details')
          .set({'notificationToken': token, 'platform': 'Android'});
      return;
    }
    return;
  }

  void _makeUserOnline() {
    FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser.uid + "/status/").set("online");
    FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser.uid + "/status/").onDisconnect().set("offline");
  }

  static final FlutterFirebaseChatSDK _instance = FlutterFirebaseChatSDK._privateConstructor();

  static FlutterFirebaseChatSDK get instance => _instance;

  final FirebaseMessaging _fcm = FirebaseMessaging();
}
