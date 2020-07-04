import 'dart:convert';

class PostOrgView {
  int _postID;
  int _organisationID;
  String _text;
  String _time;
  String _imagePath;
  String _name;
  String _organisationPhoto;

  int get organisationID => _organisationID;
  String get text => _text;
  String get time => _time;
  String get imagePath => _imagePath;
  int get postID => _postID;
  String get organisationPhoto => _organisationPhoto;
  String get name => _name;

  PostOrgView(postID, organisationID, text, time, image, orgPhoto, name) {
    this._imagePath = image;
    this._time = time;
    this._text = text;
    this._organisationID = organisationID;
    this._name = name;
    this._organisationPhoto = orgPhoto;
    this._postID = postID;
  }

  Map<String, dynamic> toMap() {
    return {
      "text": _text,
      "time": _time,
      "organisationID": _organisationID,
      "imagePath": _imagePath,
      "orgImagePath": _organisationPhoto,
      "name": _name,
      "id": _postID,
    };
  }

  PostOrgView.fromObject(dynamic map) {
    this._organisationID = map["organisationID"];
    this._text = map["text"];
    this._time = map["time"];
    this._imagePath = map["imagePath"];
    this._postID = map['id'];
    this._organisationPhoto = map['orgImagePath'];
    this._name = map['name'];
  }

  String toJson() => json.encode(toMap());

  static PostOrgView fromJson(String source) =>
      PostOrgView.fromObject(json.decode(source));
}
