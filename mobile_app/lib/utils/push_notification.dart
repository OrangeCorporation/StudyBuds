import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_buds/network/request/save_firebase_token_request.dart';
import 'package:study_buds/utils/shared_preference_helper.dart';

class PushNotificationService {
  static PushNotificationService instance = PushNotificationService();
  bool _hasToSendTokenToServer = true;
  StreamSubscription? foregroundNotifSubscription;

  void registerToForegroundNotificationStream(){
    if(foregroundNotifSubscription != null){
      foregroundNotifSubscription!.cancel();
    }
    foregroundNotifSubscription = FirebaseMessaging.onMessage.listen(_OnMessageArrived);
  }

  void unregisterToForegroundNotificationStream(){
    if(foregroundNotifSubscription != null){
      foregroundNotifSubscription!.cancel();
    }
    foregroundNotifSubscription = null;
  }

  void _OnMessageArrived(RemoteMessage message){
    if (message.notification != null) {
      Fluttertoast.showToast(msg: message.notification!.body!, backgroundColor: const Color.fromRGBO(15,107,255, 1),
                              textColor: Colors.white, gravity: ToastGravity.TOP, toastLength: Toast.LENGTH_LONG);
    }
  }


  Future<void> retrievePushNotificationToken() async {
    await FirebaseMessaging.instance.requestPermission();

    var token = await FirebaseMessaging.instance.getToken();
    print(token);
    if(token != null){
      log(token.toString());
      var oldToken = await SharedPreferencesHelper.getPushNotificationToken();
      if(oldToken != token){
        _hasToSendTokenToServer = true;
        SharedPreferencesHelper.setPushNotificationToken(token);
      }
    }
  }

  void refreshToken(){
    sendNotificationTokenToServer();
  }

  void sendNotificationTokenToServer() async {
    _hasToSendTokenToServer = false;
    var token = await SharedPreferencesHelper.getPushNotificationToken();
    if(token == null)
      return;
    print('-------- notification token ${token}');
    var response = await SaveFirebaseTokenRequest(token: token, studentId: 10).send();
    print('------------- response status: ${response.statusCode}');
    print('--------------- message: ${response.data}');
    if(response.statusCode == 200)
      print("TOKEN SAVED");
  }

}