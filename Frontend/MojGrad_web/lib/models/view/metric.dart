import 'dart:convert';

class Metric {
  int _numberOfUsers; //all
  int _numberOfMobileUsers;
  int _numberOfOrganisations;
  int _numberOfPosts;
  String _averageGrade;

  int get numberOfUsers => _numberOfUsers; //all
  int get numberOfMobileUsers => _numberOfMobileUsers;
  int get numberOfOrganisations => _numberOfOrganisations;
  int get numberOfPosts => _numberOfPosts;
  String get averageGrade => _averageGrade;

  Metric(user, org, mob, posts, avg) {
    this._numberOfUsers = user;
    this._numberOfOrganisations = org;
    this._averageGrade = avg;
    this._numberOfMobileUsers = mob;
    this._numberOfPosts = posts;
  }

  Map<String, dynamic> toMap() {
    return {
      'numberOfUsers': _numberOfUsers,
      'numberOfMobileUsers': _numberOfMobileUsers,
      'numberOfOrganisations': _numberOfOrganisations,
      'numberOfPosts': _numberOfPosts,
      'averageGrade': _averageGrade,
    };
  }

  Metric.fromObject(dynamic map) {
    this._numberOfUsers = map['numberOfUsers'];
    this._numberOfMobileUsers = map['numberOfMobileUsers'];
    this._numberOfOrganisations = map['numberOfOrganisations'];
    this._numberOfPosts = map['numberOfPosts'];
    this._averageGrade = map['averageGrade'];
  }

  String toJson() => json.encode(toMap());

  static Metric fromJson(String source) =>
      Metric.fromObject(json.decode(source));
}
