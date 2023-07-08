
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    importance: Importance.max,
  );
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> initNotification() async {
   
    
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("getToken: $fcmToken");
    signNotification();
    sharedPreferences.setString(keyShared.TOKENNOTIFICATION, fcmToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      showNotification(event);
    });
    
  }

  static Future<dynamic> onSelectNotification(payload) async {
    print("payload $payload");
  }

  static Future<void> handleBackgroundMessage(RemoteMessage remote) async {
    print('title:${remote.notification!.title}');
    print('body:${remote.notification!.body}');
    print('payload:${remote.data}');
    await Firebase.initializeApp();
    return showNotification(remote);
  }

  static Future<void> signNotification() async {
    //init notifi
   
      var initializationSettingsAndroid =
        const AndroidInitializationSettings("@drawable/ic_notification");
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);
    
    
  }

  static Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? data = message.notification;
    AndroidNotification? android = message.notification!.android;
    if (data != null) {
      flutterLocalNotificationsPlugin.show(
          0,
          data.title,
          data.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                icon: android?.smallIcon, setAsGroupSummary: true),
          ),
          payload: "referenceName");
    }
  }
}
