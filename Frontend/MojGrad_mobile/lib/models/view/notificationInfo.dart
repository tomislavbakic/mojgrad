import 'dart:convert';

class NotificationInfo {
  int _id;
  int _userID;
  bool _isRead;
  String _message;
  int _userNotificationMakerID;
  String _title;
  int _typeOfNotification;
  /*
    type 1 = >   rank change
    type 2 = >   newlike for my post
    type 3 = >   newComment on my post
    type 4 = >   newSolution for my problem
    type 5 = >   my solution is awarded  
  */
  int _newThingID;
  String _userNotificationMakerPhoto;
  int _notificationForID;

  int get id => _id;
  int get userID => _userID;
  bool get isRead => _isRead;
  String get title => _title;
  String get message => _message;
  int get notificationMakerID => _userNotificationMakerID;
  String get notificationMakerPhoto => _userNotificationMakerPhoto;
  int get notificationType => _typeOfNotification;
  int get notificationPointer => _newThingID;
  int get notificationForID => _notificationForID;

  NotificationInfo(id, userID, type, isRead, title, message,
      userNotificationMakerID, newThingID, userNotificationMakerPhoto) {
    _id = id;
    _isRead = isRead;
    _userID = userID;
    _message = message;
    _userNotificationMakerID = userNotificationMakerID;
    _userNotificationMakerPhoto = userNotificationMakerPhoto;
    _typeOfNotification = type;
    _newThingID = newThingID;
    _title = title;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'userID': _userID,
      'isRead': _isRead,
      'message': _message,
      'userNotificationMakerID': _userNotificationMakerID,
      'typeOfNotification': _typeOfNotification,
      'newThingID': _newThingID,
      'userNotificationMakerPhoto': _userNotificationMakerPhoto,
      'title': _title,
      'notificationForID' : _notificationForID
    };
  }

  NotificationInfo.fromObject(dynamic map) {
    _id = map['id'];
    _userID = map['userID'];
    _isRead = map['isRead'];
    _message = map['message'];
    _userNotificationMakerID = map['userNotificationMakerID'];
    _typeOfNotification = map['typeOfNotification'];
    _newThingID = map['newThingID'];
    _userNotificationMakerPhoto = map['userNotificationMakerPhoto'];
    _title = map['title'];
    _notificationForID = map['notificationForID'];
  }

  String toJson() => json.encode(toMap());

  static NotificationInfo fromJson(String source) =>
      NotificationInfo.fromObject(json.decode(source));
}
