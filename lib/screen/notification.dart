// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_cli/screen/notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  void firebaseMessaging() async {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
    } else {
      print("Failed to retrieve FCM token.");
    }

    // Foreground notification with dialog
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Message Body";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              body,
              maxLines: 1,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailScreen(
                        title: title,
                        body: body,
                      ),
                    ),
                  );
                },
                child: Text("View Details"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    });

    // Background (app opened from notification tap)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Message Body";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailScreen(
            title: title,
            body: body,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseMessaging();

    // Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final title = message.notification?.title ?? "No Title";
        final body = message.notification?.body ?? "No Message Body";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetailScreen(
              title: title,
              body: body,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          "Push Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text("No new notifications"),
      ),
    );
  }
}
