//
// created by Nishith.
//

import 'package:example/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_sdk/flutter_firebase_chat_sdk.dart';
import 'package:flutter_firebase_chat_sdk/friends/friends.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final friendUserIdTextController = useTextEditingController();
    _showDialog() async {
      await showDialog<String>(
        context: context,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: friendUserIdTextController,
                  autofocus: true,
                  decoration: new InputDecoration(labelText: 'Friend email', hintText: 'eg. your.friend@id.com'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Add'),
                onPressed: () async {
                  await Friends.addFriend(friendUserIdTextController.text);
                  Navigator.pop(context);
                })
          ],
        ),
      );
    }

    final groups = useValueListenable(FlutterFirebaseChatSDK.instance.groups);
    final groupNameMap = useValueListenable(FlutterFirebaseChatSDK.instance.groupToNameMap);
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () => _showDialog())],
        ),
        body: groups == null
            ? CupertinoActivityIndicator()
            : ListView.builder(
                itemCount: groups.length,
                itemBuilder: (_, int index) => ListTile(
                  title: Text(
                    groupNameMap[groups[index].id] ?? 'New chat',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    groups[index].recentMessage?.message ?? 'New group',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => ChatWidget(
                            groupId: groups[index].id,
                          ))),
                ),
              ));
  }
}
