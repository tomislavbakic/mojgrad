//this class is for data from API, contain all user data
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:webproject/config/configuration.dart';

class UserInfo {
  int _id;
  String _name;
  String _lastname;
  String _email;
  int _eko;
  int _cityID;
  int _rankID;
  String _cityName;
  String _rankName;
  int _postsNumber;
  int _commentsNumber;
  String _photo;
  String _rankImage;
  int _isBlocked;
  int _commentReportsNumber;
  int _postReportsNumber;
  int _userReportsNumber;
  int _allReportsNumber;

  UserInfo(
      name,
      lastname,
      email,
      eko,
      cityID,
      rankID,
      cityName,
      rankName,
      postNum,
      commNum,
      photo,
      rankImage,
      isBlocked,
      commentReportsNumber,
      postReportsNumber,
      userReportsNumber,
      allReportsNumber) {
    this._name = name;
    this._lastname = lastname;
    this._email = email;
    this._cityID = cityID;
    this._eko = eko;
    this._rankID = rankID;
    this._cityID = cityID;
    this._cityName = cityName;
    this._postsNumber = postNum;
    this._commentsNumber = commNum;
    this._photo = photo;
    this._rankImage = rankImage;
    this._isBlocked = isBlocked;
    this._commentReportsNumber = commentReportsNumber;
    this._postReportsNumber = postReportsNumber;
    this._userReportsNumber = userReportsNumber;
    this._allReportsNumber = allReportsNumber;
  }
  UserInfo.id(
      id,
      name,
      lastname,
      email,
      eko,
      cityID,
      rankID,
      cityName,
      rankName,
      postNum,
      commNum,
      photo,
      rankImage,
      isBlocked,
      commentReportsNumber,
      postReportsNumber,
      userReportsNumber,
      allReportsNumber) {
    this._id = id;
    this._name = name;
    this._lastname = lastname;
    this._email = email;
    this._cityID = cityID;
    this._eko = eko;
    this._rankID = rankID;
    this._cityID = cityID;
    this._cityName = cityName;
    this._postsNumber = postNum;
    this._commentsNumber = commNum;
    this._photo = photo;
    this._rankImage = rankImage;
    this._isBlocked = isBlocked;
    this._commentReportsNumber = commentReportsNumber;
    this._postReportsNumber = postReportsNumber;
    this._userReportsNumber = userReportsNumber;
    this._allReportsNumber = allReportsNumber;
  }

//geters
  String get fullname => _name + " " + _lastname;
  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get lastname => _lastname;
  int get cityID => _cityID;
  int get eko => _eko;
  int get rankID => _rankID;
  String get cityName => _cityName;
  String get rankName => _rankName;
  int get postsNumber => _postsNumber;
  int get commentsNumber => _commentsNumber;
  String get photo => _photo;
  String get rankImage => _rankImage;

  int get commentReportsNumber => _commentReportsNumber;
  int get postReportsNumber => _postReportsNumber;
  int get userReportsNumber => _userReportsNumber;
  int get allReportsNumber => _allReportsNumber;

  bool get isBlocked {
    if (_isBlocked == 1)
      return true;
    else
      return false;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['name'] = _name;
    map['lastname'] = _lastname;
    map['email'] = _email;
    map['cityID'] = _cityID;
    map['eko'] = _eko;
    map['rankID'] = _rankID;
    map['cityName'] = _cityName;
    map['rankName'] = _rankName;
    map['postsNumber'] = _postsNumber;
    map['commentsNumber'] = _commentsNumber;
    map['photo'] = _photo;
    map['rankImage'] = _rankImage;
    map['isBlocked'] = _isBlocked;
    map['commentReportsNumber'] = _commentReportsNumber;
    map['postReportsNumber'] = _postReportsNumber;
    map['userReportsNumber'] = _userReportsNumber;
    map['allReportsNumber'] = _allReportsNumber;
    return map;
  }

  UserInfo.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._lastname = o['lastname'];
    this._email = o['email'];
    this._cityID = o['cityID'];
    this._eko = o['eko'];
    this._rankID = o['rankID'];
    this._rankName = o['rankName'];
    this._cityName = o['cityName'];
    this._postsNumber = o['postsNumber'];
    this._commentsNumber = o['commentsNumber'];
    this._rankImage = o['rankImage'];
    this._photo = o['photo'];
    this._isBlocked = o['isBlocked'];
    this._commentReportsNumber = o['commentReportsNumber'];
    this._postReportsNumber = o['postReportsNumber'];
    this._userReportsNumber = o['userReportsNumber'];
    this._allReportsNumber = o['allReportsNumber'];
  }

  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future<UserInfo> fetchUserDataByID(int id) async {
    String url = userDatasURL + "/$id";
    print(url);
    var res = await http.get(url, headers: header);
    var data = convert.jsonDecode(res.body);

    UserInfo userData = UserInfo.fromObject(data);

    print(userData._email);
    print(res.body);

    return userData;
  }
}
