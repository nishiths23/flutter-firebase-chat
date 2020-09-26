/**
 * created by Nishith on 20/09/20.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_sdk/auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toast/toast.dart';

import 'home.dart';

class Login extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final emailTextController = useTextEditingController();
    emailTextController.text = 'nishithsingh23@ymail.com';
    final passwordTextController = useTextEditingController();
    passwordTextController.text = '123456';
    AppLifecycleState;
    final showLoading = useState(false);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Email'),
                controller: emailTextController,
              ),
              TextFormField(
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Password'),
                controller: passwordTextController,
              ),
              MaterialButton(
                child: Text('Login'),
                onPressed: () async {
                  showLoading.value = true;
                  final userId = await Auth.signIn(emailTextController.text, passwordTextController.text);
                  if (userId != null) {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute<void>(builder: (BuildContext context) => Home()));
                  } else {
                    Toast.show('Unable to sign in', context);
                  }
                },
              ),
              showLoading.value ? CupertinoActivityIndicator() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
