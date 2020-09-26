# flutter_firebase_chat_sdk
[![GitHub license](https://img.shields.io/github/license/nishiths23/flutter-firebase-chat)](https://github.com/nishiths23/flutter-firebase-chat/blob/master/LICENSE)
![Pub Version](https://img.shields.io/pub/v/flutter_firebase_chat_sdk)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/nishiths23/flutter-firebase-chat/Dart%20CI)

A package that used the power of firebase to create a chat SDK.

Motivation behind this project was to create an all in one sdk that would make it easier for developers to create a chat app. Using this SDK developers can focus on the basic functionality of their app rather then worrying about setting up and developing a chat server.

The project is still in development phase but you are welcome to use it in your app and contribute to the project if you needed some more features or if you would like to improve something.

**Demo**

![](example/lib/demo/demo.gif)

## Getting Started

- Using <a href="https://firebase.google.com/docs/flutter/setup?platform=android" target="_blank">**this**</a> link setup Firebase in your app
- Setup Authentication, Cloud Firestore, Realtime Database and Storage on your Firebase project
- Add ```await FlutterFirebaseChatSDK.initializeApp()``` to your ```main()``` method

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterFirebaseChatSDK.initializeApp();
  runApp(MyApp());
}
```
- Wrap your app with ```FlutterFirebaseObservableApp``` widget so that the SDK could monitor the status of the app which is needed to update the online status of the user. So for example your main app widget could be:

```dart
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
```
- It is also a good idea from security purposes to perform some operations from the server and not give access to client for them. One of the example for this is the ```addFriend``` function which calls a firebase functions and invokes the firebase admin SDK to add a new friend and create a chat group with current user and the given friend id.

- Use <a href="https://firebase.google.com/docs/functions/get-started" target="_blank">**this**</a> link to setup firebase CLI on your system and firebase functions in your project and then add code from `lib/firebase/firebase-functions.js` to the `index.js` file of your firebase functions project and run ```npm install uuidv4``` to install <a href="https://www.npmjs.com/package/uuidv4" target="_blank">**uuidv4**</a> dependency.

- The project also uses firebase collection group so add the following rules to your CloudFirestore rules

```
match /{path=**}/Channels/{channelId} {
    	allow read, write: if request.auth != null
    }
```

- It might be a good idea to add strict rules to your project including your Cloud Firestore, Realtime Database and Storage to prevent anykinds of attack on your Firebase project and causing you finantial loss.
<a href="https://firebase.google.com/docs/database/security" target="_blank">**Realtime database rules**</a>, <a href="https://firebase.google.com/docs/firestore/security/get-started" target="_blank">**Cloud firestore rules**</a>, <a href="https://firebase.google.com/docs/storage/security/get-started" target="_blank">**Storage rules**</a> these links could be a good starting point to setting up security rules for protecting your project from any kind of attacks.

---
## Running the example project

> Once the above steps are followed run ```flutter pub get``` in the base folder and in example folder, then you can directly run the example project on a device or a simulator.
---

## Future plans
- End to end encryption
- Add members to group
- Display user online status

### Libraries used in example

```
  google_sign_in
  flutter_hooks
  toast
  dash_chat
  image_picker
  flutter_native_image
```

If you have any issues building or running example project please consider following installation instructions for these dependencies before creating opening an issue.

# Support Development
If you found this project helpful or you learned something from the source code and want to thank me, consider buying me a cup of ☕️

[PayPal](https://paypal.me/NishithNirbhay)

[<img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="60px" width="200px"/>](https://www.buymeacoffee.com/nsingh)


## Found this project useful? ❤️

If you found this project useful, then please consider giving it a ⭐️ on Github and sharing it with your friends via social media.


## License ⚖️

- [MIT](LICENSE)

## Issues and feedback 💭

If you have any suggestion for including a feature or if something doesn't work, feel free to open a Github [issue](https://github.com/nishiths23/flutter-firebase-chat/issues) for us to have a discussion on it.
