import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final notification = flutterLocalNotificationsPlugin;

            const android = AndroidNotificationDetails(
              '0',
              "알림 테스트",
              channelDescription: "알림 테스트 바디 부분",
              importance: Importance.max,
              priority: Priority.max,
            );
            const ios = IOSNotificationDetails();
            const detail = NotificationDetails(
              android: android, 
              iOS: ios,
            );

            final permission = Platform.isAndroid
                ? true
                : await notification
                        .resolvePlatformSpecificImplementation<
                            IOSFlutterLocalNotificationsPlugin>()
                        ?.requestPermissions(alert: true, badge: true, sound: true) ??
                    false;
            print('permission $permission');

            if (!permission){
              return;
            }
            
            await flutterLocalNotificationsPlugin.show(
              0, 'plain title', 'plain body', detail,
              );
        }, child: const Text("alarm"),
        ),
      ),
        
    );
  }
}