import 'dart:convert';

class GenderInfo {
  int _numberOfMale;
  int _numberOfFemale;
  String _percentOfMale;
  String _percentOfFemale;
  String _averageAge;

  int get numberOfMale => _numberOfMale;
  int get numberOfFemale => _numberOfFemale;
  String get percentOfMale => _percentOfMale;
  String get percentOfFemale => _percentOfFemale;
  String get averageAge => _averageAge;

  GenderInfo(user, org, mob, posts, avg) {
    this._numberOfMale = user;
    this._numberOfFemale = org;
    this._percentOfMale = avg;
    this._percentOfFemale = mob;
    this._averageAge = posts;
  }

  Map<String, dynamic> toMap() {
    return {
      'numberOfMale': _numberOfMale,
      'numberOfFemale': _numberOfFemale,
      'percentOfMale': _percentOfMale,
      'percentOfFemale': _percentOfFemale,
      'averageAge': _averageAge,
    };
  }

  GenderInfo.fromObject(dynamic map) {
    this._numberOfMale = map['numberOfMale'];
    this._numberOfFemale = map['numberOfFemale'];
    this._percentOfMale = map['percentOfMale'];
    this._percentOfFemale = map['percentOfFemale'];
    this._averageAge = map['  averageAge'];
  }

  String toJson() => json.encode(toMap());

  static GenderInfo fromJson(String source) =>
      GenderInfo.fromObject(json.decode(source));
}
