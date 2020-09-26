//
// created by Nishith on 19/09/20.
//
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_chat_sdk/chat/message.dart';
import 'package:flutter_firebase_chat_sdk/src/constants.dart';

class Chat {
  final String groupId;
  final int limit;

  Chat({this.groupId, this.limit = 10}) {
    Constants.activeGroup = groupId;
    moreMessagesAvailable = true;
    FirebaseFirestore.instance.collection('Groups/$groupId/messages').orderBy('timestamp', descending: false).limitToLast(limit).snapshots().listen((event) {
      _chatDocuments = (_chatDocuments + event.docs)..sort((a, b) => DateTime.parse(a.data()['timestamp']).compareTo(DateTime.parse(b.data()['timestamp'])));
      _chat.value = event.docs.map((e) => Message.fromJson(e.data())..id = e.id).toList();
    });
    FirebaseFirestore.instance.doc('Channels/$groupId').update({
      'readBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])
    });
  }

  ///
  /// Send an image message in the given group id
  ///
  Future<void> sendImageMessage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child('Images').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    final url = await storageTaskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('/Groups/$groupId/messages').add({
      'from': FirebaseAuth.instance.currentUser.uid,
      'status': 'sent',
      'timestamp': DateTime.now().toIso8601String(),
      'message': '',
      'fromName': FirebaseAuth.instance.currentUser.displayName,
      'groupId': groupId,
      'image': url
    });
    return;
  }

  ///
  /// Get previous messages
  ///
  Future<void> getPreviousMessages() async {
    final newMessages = await FirebaseFirestore.instance
        .collection('Groups/$groupId/messages')
        .orderBy('timestamp', descending: false)
        .limitToLast(30)
        .endBeforeDocument(_chatDocuments[0])
        .get();
    if (newMessages.docs.length < limit) {
      moreMessagesAvailable = false;
    } else {
      moreMessagesAvailable = true;
    }
    _chatDocuments = (_chatDocuments + newMessages.docs)
      ..sort((a, b) => DateTime.parse(a.data()['timestamp']).compareTo(DateTime.parse(b.data()['timestamp'])));
    _chat.value = _chatDocuments.map((e) => Message.fromJson(e.data())..id = e.id).toList();
    return;
  }

  ///
  /// More messages available or not
  ///
  bool moreMessagesAvailable = true;

  ///
  /// Observe group for messages
  ///
  ValueNotifier<List<Message>> get messages => _chat;
  ValueNotifier<List<Message>> _chat = ValueNotifier([]);
  List<QueryDocumentSnapshot> _chatDocuments = [];

  ///
  /// Send a text message in the given group id
  ///
  Future<void> sendTextMessage({@required String message}) => FirebaseFirestore.instance.collection('/Groups/$groupId/messages').add({
        'from': FirebaseAuth.instance.currentUser.uid,
        'status': 'sent',
        'timestamp': DateTime.now().toIso8601String(),
        'message': message,
        'fromName': FirebaseAuth.instance.currentUser.displayName,
        'groupId': groupId
      });
}
