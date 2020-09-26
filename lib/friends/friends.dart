/**
 * created by Nishith on 20/09/20.
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_firebase_chat_sdk/auth/auth.dart';

class Friends {
  static Future<bool> addFriend(String friendEmailId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'addFriend')..timeout = const Duration(seconds: 30);
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{'friendID': friendEmailId},
    );
    if (result.data == null || result.data['status'] == null) {
      Future.error(Error(code: 'UNKNOWN', message: 'Something went wrong'));
    }
    if (result.data['status'] == 'failure') {
      Future.error(Error(code: result.data['message'], message: ''));
    }
    return true;
  }
}
