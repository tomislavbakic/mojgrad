import 'dart:convert';

class Comment {
  int _id;
  String _text;
  int _postID;
  int _userDataID;
  DateTime _time;
  String _commentPhoto;

  Comment(text, postID, userDataID, time, imageURL) {
    this._text = text;
    this._postID = postID;
    this._userDataID = userDataID;
    this._time = time;
    this._commentPhoto = imageURL;
  }

  int get id => _id;
  String get text => _text;
  int get postID => _postID;
  int get userDataID => _userDataID;
  String get imageURL => _commentPhoto;
  

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['text'] = _text;
    map['postID'] = _postID;
    map['userDataID'] = _userDataID;
    map['time'] = _time.toIso8601String();
    map['commentPhoto'] = _commentPhoto;
    return map;
  }

  Comment.fromObject(dynamic map) {
    _id = map['id'];
    _text = map['text'];
    _postID = map['postID'];
    _userDataID = map['userDataID'];
    _time = map['time'];
    _commentPhoto = map['commentPhoto'];
  }

  String toJson() => json.encode(toMap());

  static Comment fromJson(String source) =>
      Comment.fromObject(json.decode(source));
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  
}
