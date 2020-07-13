// Replace with server token from firebase console settings.
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

final String serverToken = 'AAAAY6IGoPo:APA91bHNxgG2hfe4e9ah1VqUrbEKUoQrSe8S7AEbQpkpKZPyxaEvFLB26UA_ZAq03YzHkRDfH3hdbiMONS8ZXGG82MZWThM_YvegGef2D6pkcKLBXI7aFCzTDKZS6Kcc8-kIYYVUIc3z';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
Future<Map<String, dynamic>> sendAndRetrieveMessage({String tokenId, String title, String body}) async {
 // print(tokenId);
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );
var hhh=  await http.post(
    'https://fcm.googleapis.com/fcm/send',
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': '$body',
         'title': '$title',
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': tokenId,
       //await firebaseMessaging.getToken(),
     },
    ),
  );
  final Completer<Map<String, dynamic>> completer =
     Completer<Map<String, dynamic>>();
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );
  print(hhh.body);
  return completer.future;
}