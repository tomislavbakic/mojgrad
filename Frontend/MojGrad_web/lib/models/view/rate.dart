import 'dart:convert';

class Rate
{
  int _id;
  double _averageRate;
  int _voteCount;

  int get id => _id;
  double get averageRate => _averageRate;
  int get voteCount => _voteCount;

  Rate(id,avg,count)
  {
    this._id = id;
    this._averageRate = avg;
    this._voteCount = _voteCount;
  }

   Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'averageRate': _averageRate,
      'voteCount': _voteCount,
    };
  }

  Rate.fromObject(dynamic map) {
    this._id = map['id'];
    this._averageRate = map['averageRate'];
    this._voteCount = map['voteCount'];
  }

  String toJson() => json.encode(toMap());

  static Rate fromJson(String source) =>
      Rate.fromObject(json.decode(source));



}