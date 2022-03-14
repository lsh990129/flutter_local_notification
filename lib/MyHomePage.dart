import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


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

            if (!permission){
              return;
            }

            // await flutterLocalNotificationsPlugin.show(
            //   0, 'plain title', 'plain body', detail,
            //   );

            // 타임존 셋팅 필요
            final now = tz.TZDateTime.now(tz.local);

            await notification.zonedSchedule(
              1,
              'alarmTitle',
              'alarmDescription',
              tz.TZDateTime(
                tz.local,
                now.year,
                now.month,
                now.day,
                now.hour,
                now.minute + 1,
              ),
              detail,
              androidAllowWhileIdle: true, // 저전력 유휴 모드인 경우 알람 전달 여부
              uiLocalNotificationDateInterpretation: // 예약된 날짜를 절대 시간으로 해석할지 벽시계 시간으로 해석할지 결정
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time, // 주기 설정
            ); 
        }, child: const Text("alarm"),
        ),
      ),
        
    );
  }
}