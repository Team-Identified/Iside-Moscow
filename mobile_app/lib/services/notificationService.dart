import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:mw_insider/services/authorizationService.dart';
import 'package:mw_insider/services/uiService.dart';
import 'backendCommunicationService.dart';


FlutterLocalNotificationsPlugin localNotification;

class Notifier {
  Notifier(){
    var androidInitialize = new AndroidInitializationSettings('small_logo');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future showNotification({
    String title="Notification title",
    String description="Notification description",
    Importance importance=Importance.high,
  }) async {
    var androidDetails = new AndroidNotificationDetails(
      "channelId",
      "Local Notification",
      "This is a description",
      importance: importance,
    );
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await localNotification.show(0, title, description, generalNotificationDetails);
  }
}


void checkNearbyObjectNotification(LocationData locationData) async {
  bool isLogged = await isLoggedIn();
  if (!isLogged)
    return;

  Map requestData = {
    "latitude": locationData.latitude,
    "longitude": locationData.longitude,
  };
  Map response = await serverRequest('post',
      'geo_objects/nearby_object_notification', requestData);
  if (response["need_to_notify"]){
    Notifier notifier = Notifier();
    notifier.showNotification(
      title: "Объект близко",
      description:
      "${capitalize(response['object']['category'])} "
        "${response['object']['name_ru']} на расстоянии "
        "${response['distance']}м",
      importance: Importance.high,
    );
  }
}
