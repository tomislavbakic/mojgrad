import 'dart:convert';

class RanksInfo {
  int _id;
  String _name;
  String _urlPath;
  int _minPoints;
  int _maxPoints;

  int get id => _id;
  String get name => _name;
  String get urlPath => _urlPath;
  int get minPoints => _minPoints;
  int get maxPoints => _maxPoints;

  RanksInfo(id,name, url, min, max) {
    this._id = id;
    this._name = name;
    this._urlPath = url;
    this._minPoints = min;
    this._maxPoints = max;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['urlPath'] = _urlPath;
    map['minPoints'] = _minPoints;
    map['maxPoints'] = _maxPoints;
    return map;
  }

  RanksInfo.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._urlPath = o['urlPath'];
    this._minPoints = o['minPoints'];
    this._maxPoints = o['maxPoints'];
  }

  String toJson() => json.encode(toMap());

  static RanksInfo fromJson(String source) => RanksInfo.fromObject(json.decode(source));
}
