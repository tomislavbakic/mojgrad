import 'dart:convert';
import 'package:http/http.dart';
import 'package:webproject/config/configuration.dart';

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

  static get commentImageUploadURL => null;
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

/*
  static Future<bool> addNewComment(Comment c, File image) async {
    String url = commentURL;
    var myComment = c.toMap();

    var jsonBody = json.encode(myComment);
    print(
        "OVO JE ADRESA GTE BI TREBALO DA SE UPLOADUJE SLIKA NA SERVER: $commentImageUploadURL");
    uploadImage(image, commentImageUploadURL);
    var res = await post(url, headers: header, body: jsonBody);
    print("res.statusCode from addNewComment - " + res.statusCode.toString());
    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }*/

  static Future<void> commentReaction(
      String jwt, int commentID, int userID, int reaction) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var data = Map();
    data['commentID'] = commentID;
    data['userDataID'] = userID;
    data['likeOrDislike'] = reaction; //moze da bude -1 ili 1

    var jsonBody = jsonEncode(data);

    var res = await post(commentReactionURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);

    print("Comment status code  ${res.statusCode}");
    print("Comment res.body: ${res.body}");
  }
}
