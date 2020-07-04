import 'dart:convert';

import 'package:http/http.dart';
import 'package:webproject/config/configuration.dart';

class UserLike {
  int _id;
  String _name;
  String _lastname;
  String _email;
  String _photo;
  int _eko;

  int get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get photo => _photo;
  int get eko => _eko;

  UserLike(id, name, lastname, email, photo, eko) {
    this._eko = eko;
    this._email = email;
    this._id = id;
    this._photo = photo;
    this._name = name;
    this._lastname = lastname;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'photo': _photo,
      'name': _name,
      'lastname': _lastname,
      'email': _email,
      'eko': _eko,
    };
  }

  UserLike.fromObject(dynamic map) {
    this._id = map['id'];
    this._name = map['name'];
    this._lastname = map['lastname'];
    this._email = map['email'];
    this._eko = map['eko'];
    this._photo = map['photo'];
  }

  static Future<List<UserLike>> getUsersWhoLikedPost(
      String jwt, int idPost) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();

    var res = await get(userWhoLikePostURL + "/$idPost", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    print("getUsersWhoLikedPost" + res.statusCode.toString());

    List<UserLike> userList = new List<UserLike>();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      for (var item in data) {
        userList.add(UserLike.fromObject(item));
      }
      return userList;
    }
    return null;
  }
}
