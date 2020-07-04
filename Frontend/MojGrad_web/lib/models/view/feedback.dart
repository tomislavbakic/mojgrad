import 'dart:convert';

class FeedbackInfo {
  int _id;
  int _userDataId;
  String _text;
  String _fullName;
  String _userPhoto;

  String get userPhoto => _userPhoto;
  int get id => _id;
  int get userDataId => _userDataId;
  String get text => _text;
  String get fullName => _fullName;

  FeedbackInfo(id,userId,fullName,text,userPhoto)
  {
    this._userPhoto = userPhoto;
    this._fullName = fullName;
    this._id = id;
    this._text = text;
    this._userDataId = userId;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'userDataId': _userDataId,
      'text': _text,
      'fullName': _fullName,
      'userPhoto' : _userPhoto,
    };
  }

  FeedbackInfo.fromObject(dynamic map) {
    this._id = map['id'];
    this._userDataId = map['userDataId'];
    this._fullName = map['fullName'];
    this._text = map['text'];
    this._userPhoto = map['userPhoto'];
  }

  String toJson() => json.encode(toMap());

  static FeedbackInfo fromJson(String source) => FeedbackInfo.fromObject(json.decode(source));
}
