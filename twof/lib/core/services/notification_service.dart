import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationService() {
    _initializeNotifications();
    _requestPermissions();
    _configureFCM();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _requestPermissions() async {
    // Request permissions for iOS notifications if needed
    await _firebaseMessaging.requestPermission();
  }

  void _configureFCM() {
    // Listen for FCM notifications when app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(
          message.notification!.title ?? "New message",
          message.notification!.body ?? "",
        );
      }
    });
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Unique notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> saveFCMToken(String userId) async {
    // Save the FCM token for each user in Firestore
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  Future<void> sendPushNotification(
      String userId, String sender, String message) async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();
    String? fcmToken = userDoc['fcmToken'];

    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'to': fcmToken,
        'notification': {
          'title': 'New message from $sender',
          'body': message,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'message',
        },
      });
    }
  }

  Future<void> checkForNewMessages(String? userId) async {
    // Query for new messages targeting the specific user
    QuerySnapshot newMessages = await firestore
        .collection("chats")
        .where("isNew", isEqualTo: true)
        .where("receiverId", isEqualTo: userId)
        .get();

    for (var doc in newMessages.docs) {
      sendPushNotification(userId!, doc["sender"], doc["message"]);
      // Mark message as read or remove "isNew" field
      await doc.reference.update({"isNew": false});
    }
  }
}
