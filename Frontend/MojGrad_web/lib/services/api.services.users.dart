import 'dart:convert';

import 'package:http/http.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/view/blockedUser.dart';
import 'package:webproject/models/view/userInfo.dart';
import 'package:http/http.dart' as http;

class APIServicesUsers {
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //fetch all users from database
  static Future<List<UserInfo>> fetchAllUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http.get(userDatasURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<UserInfo> userList = new List<UserInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        userList.add(UserInfo.fromObject(item));
      }
      return userList;
    }
    return null;
  }

  static Future<void> blockUser(String jwt, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['userDataID'] = userID;
    map['blockedUntil'] =
        DateTime.now().add(new Duration(days: 7)).toIso8601String();
    map['reason'] = "Neprimereno ponasanje";
    var blockBody = jsonEncode(map);
    var res = await post(blockedUsersURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: blockBody);
    print(res.statusCode);
    print(res.body);
  }

  static Future<List<BlockedUser>> fetchBlockedUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(blockedUsersURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<BlockedUser> userList = new List<BlockedUser>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        userList.add(BlockedUser.fromObject(item));
      }
      return userList;
    }
    return null;
  }

  static Future<List<UserInfo>> fetchTopEkoUsersN(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(topEkoUsersURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<UserInfo> userList = new List<UserInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        userList.add(UserInfo.fromObject(item));
      }
      return userList;
    }
    return null;
  }

  static Future<UserInfo> fetchUserByID(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(userDatasURL + "/$id", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    UserInfo user;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      user = UserInfo.fromObject(data);
      return user;
    }
    return null;
  }

  static Future<bool> deleteUserByID(String jwt, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response =
        await http.delete(deleteUserURL + "/$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> checkUser(String username, String password) async {
    String url = adminLoginURL;
    var data = Map();
    data['username'] = username;
    data['password'] = password;
    var jsonBody = jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  static Future<void> unblockUser(String jwt, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await delete(blockedUsersURL + "/$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    print(res.statusCode);
    print(res.body);
  }
}
