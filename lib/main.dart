import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team/initPage.dart';
import 'package:team/professor/login/initPageP.dart';
import 'package:team/professor/login/signInPage.dart';
import 'package:team/professor/login/signUpPage.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/student/login/initPage.dart';
import 'package:team/student/login/signInPage.dart';
import 'package:team/student/login/signUpPage.dart';
import 'package:team/Project/projectAddPage.dart';
import 'package:team/student/stuprojectList.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // 폰트 크기 고정
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.78),
          );
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          //login
          '/': (context) => const InitPage(),
          // '/toPro_LoginPage': (context) => const loginInitPageP(),
          '/toPro_SignInPage': (context) => const SignInPageP(),
          '/toPro_SignUpPage': (context) => const SignUpPageP(),

          // '/toStu_LoginPage': (context) => const loginInitPageS(),
          '/toStu_SignInPage': (context) => const SignInPageS(),
          '/toStu_SignUpPage': (context) => const SignUpPageS(),

          //Project
          '/toProfProjectlistPage': (context) => const ProfProjectListPage(),
          '/toStuProjectlistPage': (context) => const StuProjectListPage(),
          '/toProjectAddPage': (context) =>
          const ProjectAddPage(), // *TODO : 이후 교수의 projectListPage에서 버튼 클릭을 통해 여기로 이동할 수 있도록 설정해야 함
        });
  }
}

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (
    receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction
    ) {
      // For background actions, you must hold the execution until the end
      print('Message sent via notification input: "${receivedAction
          .buttonKeyInput}"');
      await executeLongTaskInBackground();
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: -1,
          // -1 is replaced by a random number
          channelKey: 'alerts',
          title: '팀플모아',
          body:
          "새로운 댓글이 달렸습니다!",
          bigPicture: 'assets/images/title.jpg',
          largeIcon: 'assets/images/title.jpg',
          notificationLayout: NotificationLayout.BigPicture,
      payload: {'notificationId': '1234567890'}),
    );
  }

  static Future<void> createNewNNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: -1,
          // -1 is replaced by a random number
          channelKey: 'alerts',
          title: '팀플모아',
          body:
          "새로운 답글이 달렸습니다!",
          bigPicture: 'assets/images/title.jpg',
          largeIcon: 'assets/images/title.jpg',
          notificationLayout: NotificationLayout.BigPicture,
          payload: {'notificationId': '1234567890'}),
    );
  }
}
