import 'dart:convert';

class StatisticInfo {
  int _categoryID;
  String _categoryName;
  int _numberOfPosts;
  String _percentageOfAllPosts;

  StatisticInfo(
      categoryID, categoryName, numberOfPosts, percentage) {
    this._categoryID = categoryID;
    this._categoryName = categoryName;
    this._numberOfPosts = numberOfPosts;
    this._percentageOfAllPosts = percentage;
  }

  int get categotyID => _categoryID;
  String get categoryName => _categoryName;
  int get numberOfPosts => _numberOfPosts;
  String get percentageOfAllPosts => _percentageOfAllPosts;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["categoryName"] = _categoryName;
    map["categoryID"] = _categoryID;
    map["numberOfPosts"] = _numberOfPosts;
    map["percentageOfAllPosts"] = _percentageOfAllPosts;

    return map;
  }

  StatisticInfo.fromObject(dynamic o) {
    this._percentageOfAllPosts = o["percentageOfAllPosts"];
    this._categoryID = o["categoryID"];
    this._categoryName = o["categoryName"];
    this._percentageOfAllPosts = o["percentageOfAllPosts"];
  }

  String toJson() => json.encode(toMap());

  static StatisticInfo fromJson(String source) =>
      StatisticInfo.fromObject(json.decode(source));
}
