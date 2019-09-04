import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'DatabaseManager.dart';
import 'SharedPreferences.dart';

class LocalNotificationsManager {
  FlutterLocalNotificationsPlugin notificationsPlugin;
  SharedPreferencesManager prefs = SharedPreferencesManager();
  DatabaseManager databaseManager;
  Function updateUI;

  LocalNotificationsManager() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    databaseManager = DatabaseManager();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showNotification(String title, String body, String payload,
      {Function updateUI}) async {
    if (updateUI != null) this.updateUI = updateUI;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.show(0, title, body, platformChannelSpecifics,
        payload: payload);
  }

  Future<void> onSelectNotification(String payload) async {

  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    onSelectNotification(payload);
  }

}
