import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_sdk/chat/chat.dart';
import 'package:flutter_firebase_chat_sdk/flutter_firebase_chat_sdk.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class ChatWidget extends HookWidget {
  ChatWidget({this.groupId}) : chat = Chat(groupId: groupId, limit: 30);

  final String groupId;
  final Chat chat;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    Widget buildLoading() {
      return Positioned(
        child: isLoading.value
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                ),
                color: Colors.white.withOpacity(0.8),
              )
            : Container(),
      );
    }

    final userId = FlutterFirebaseChatSDK.instance.userId;
    final messages = useValueListenable(chat.messages);
    final readBy = useValueListenable(FlutterFirebaseChatSDK.instance.groups).where((element) => element.id == groupId).toList().first.readBy;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Stack(
        children: [
          DashChat(
            shouldShowLoadEarlier: true,
            onLoadEarlier: () async {
              if (chat.moreMessagesAvailable) chat.getPreviousMessages();
            },
            onSend: (_) => chat.sendTextMessage(message: _.text),
            user: ChatUser(uid: userId),
            sendButtonBuilder: (func) => Row(
              children: [
                IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () async {
                      final image = await picker.getImage(source: ImageSource.gallery);
                      final compressedFile = await FlutterNativeImage.compressImage(image.path, quality: 80, percentage: 90);
                      final url = await chat.sendImageMessage(compressedFile);
                      print('');
                    }),
                IconButton(icon: Icon(Icons.send), onPressed: () => func()),
              ],
            ),
            messages: messages
                .map(
                  (e) => ChatMessage(
                    id: e.id,
                    text: e.message,
                    image: e.image,
                    createdAt: DateTime.parse(e.timestamp),
                    user: ChatUser(uid: e.from, name: e.fromName),
                  ),
                )
                .toList(),
          ),
          buildLoading(),
        ],
      ),
    );
  }
}
