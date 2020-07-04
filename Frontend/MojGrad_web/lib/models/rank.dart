import 'dart:convert';

class Rank {
  String _name;
  String _urlPath;
  int _minPoints;
  int _maxPoints;

  String get name => _name;
  String get urlPath => _urlPath;
  int get minPoints => _minPoints;
  int get maxPoints => _maxPoints;

  Rank(name, url, min, max) {
    this._name = name;
    this._urlPath = url;
    this._minPoints = min;
    this._maxPoints = max;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['name'] = _name;
    map['urlPath'] = _urlPath;
    map['minPoints'] = _minPoints;
    map['maxPoints'] = _maxPoints;
    return map;
  }

  Rank.fromObject(dynamic o) {
    this._name = o['name'];
    this._urlPath = o['urlPath'];
    this._minPoints = o['minPoints'];
    this._maxPoints = o['maxPoints'];
  }

  String toJson() => json.encode(toMap());

  static Rank fromJson(String source) => Rank.fromObject(json.decode(source));
}
