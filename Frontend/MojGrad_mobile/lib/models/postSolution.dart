import 'dart:convert';

class PostSolution {
  int _id;
  String _text;
  int _postID;
  int _userID;
  int _userType;
  String _imagePath;
  int _isAwarded;

  PostSolution(text, postID, userID, imagePath) {
    this._text = text;
    this._postID = postID;
    this._userID = userID;
    this._userType = 1; // 1 for users
    this._imagePath = imagePath;
    this._isAwarded = 0;
  }

  int get id => _id;
  String get text => _text;
  int get postID => _postID;
  int get userID => _userID;
  String get imagePath => _imagePath;
  int get userType => _userType;
  bool get isAwarded {
    if (this._isAwarded == 1)
      return true;
    else
      return false;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['text'] = _text;
    map['postID'] = _postID;
    map['userID'] = _userID;
    map['imagePath'] = _imagePath;
    map['isAwarded'] = _isAwarded;
    map['userType'] = _userType;
    return map;
  }

  PostSolution.fromObject(dynamic map) {
    this._id = map['id'];
    this._text = map['text'];
    this._postID = map['postID'];
    this._userID = map['userID'];
    this._imagePath = map['imagePath'];
    this._userType = map['userType'];
    this._isAwarded = map['isAwarded'];
  }

  String toJson() => json.encode(toMap());

  static PostSolution fromJson(String source) =>
      PostSolution.fromObject(json.decode(source));
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
