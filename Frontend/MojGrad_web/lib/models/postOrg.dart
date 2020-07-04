import 'dart:convert';

class PostOrg {
  int _organisationID;
  String _text;
  DateTime _time;
  String _imagePath;

  int get organisationID => _organisationID;
  String get text => _text;
  DateTime get time => _time;
  String get imagePath => _imagePath;

  PostOrg(organisationID, text, time, image) {
    this._imagePath = image;
    this._time = time;
    this._text = text;
    this._organisationID = organisationID;
  }

  Map<String, dynamic> toMap() {
    return {
      "text": _text,
      "time": _time.toIso8601String(),
      "organisationID": _organisationID,
      "imagePath": _imagePath,
    };
  }

  PostOrg.fromObject(dynamic map) {
    this._organisationID = map["organisationID"];
    this._text = map["text"];
    this._time = map["time"];
    this._imagePath = map["imagePath"];
  }

  String toJson() => json.encode(toMap());

  static PostOrg fromJson(String source) =>
      PostOrg.fromObject(json.decode(source));
}
