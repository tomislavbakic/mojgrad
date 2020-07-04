import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/functions/images.dart';
import 'package:fronend/models/userData.dart';
import 'package:fronend/models/view/userInfo.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

  //function update user password, check validy correctness of old password and update new
  static Future<bool> changePassword(
      String jwt, int userID, String oldpass, String newpass) async {
    //old pass to sha
    var sh = utf8.encode(oldpass);
    oldpass = sha1.convert(sh).toString();
    //new pass to sha
    sh = utf8.encode(newpass);
    newpass = sha1.convert(sh).toString();
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = userID;
    map['oldPassword'] = oldpass;
    map['newPassword'] = newpass;
    var putBody = json.encode(map);
    var res = await http.put(changePasswordURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);
    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  //function update user data
  static Future<bool> changeUserData(String jwt, int userID, String newName,
      String newLastname, String newEmail, int newAge, int newCityID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = userID;
    map['newName'] = newName;
    map['newLastname'] = newLastname;
    map['newEmail'] = newEmail;
    map['newAge'] = newAge;
    map['newCityID'] = newCityID;
    var putBody = json.encode(map);
    var res = await http.put(changeUserDataURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);
    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  //function update user profile picture, new image file on server and update column in database
  static Future<bool> updateProfilePicture(
      String jwt, File image, int userID, String fileName) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var map = Map();
    map['id'] = userID;
    map['photo'] = userServerPathImage + fileName;
    var putBody = json.encode(map);
    await uploadImageNew(image, userProfileImageUploadURL, fileName);
    var res = await http.put(changeUserProfileImgURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);

    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  //function check does user with this email and password exists in database
  static Future<String> checkUser(String email, String password) async {
    String url = loginURL;
    var data = Map();
    data['email'] = email;
    data['password'] = password;
    var jsonBody = jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  //function check email is this email address unique
  static Future<String> checkEmail(String email) async {
    String url = emailURL;
    var data = Map();
    data['email'] = email;
    var jsonBody = jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data_2 = res.body.toString();
    return data_2;
  }

  //registration on new user, call email validation
  static Future<int> registration(UserData user) async {
    String url = userDatasRegistrationURL;
    var data = user.toMap();
    var jsonBody = jsonEncode(data);

    var email = (await checkEmail(user.email)).toString();

    if (email == "true")
      return 0;
    else {
      var res = await http.post(url, headers: header, body: jsonBody);

      return res.statusCode;
    }
  }

  //function return all User info by userID
  static Future<UserInfo> fetchUserDataByID(String jwt, int id) async {
    String url = userDatasURL + "/$id";
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 500) return null;

    var datas = jsonDecode(res.body);
    UserInfo userData = UserInfo.fromObject(datas);
    return userData;
  }

  //function report user who write post
  static Future<void> reportUser(
      String jwt, int idUser, int reportedUserdId, String description) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['description'] = description;
    map['userDataID'] = idUser;
    map['reportedUserID'] = reportedUserdId;
    var jsonBody = jsonEncode(map);
    var res = await http.post(userReportURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
  }

  //update user data
  static Future<void> additionalUserData(
      String jwt, int userID, int cityID, int age, String gender) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var map = Map();
    map['userID'] = userID;
    map['cityID'] = cityID;
    map['age'] = age;
    map['gender'] = gender;
    var putBody = json.encode(map);
    var res = await http.put(userDatasURL + "/additionalData",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
  }

  static Future<List<UserInfo>> getSearchedUsed(
      String jwt, String search) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var map = Map();
    map['search'] = search;

    var postBody = json.encode(map);

    http.Response response = await http.post(userDatasURL + "/searchUsers",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);

    List<UserInfo> list = new List<UserInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(UserInfo.fromObject(item));
      }
      return list;
    }
    return null;
  }

  static Future<bool> resetPassword(String email) async {
    var res = await http.post(resetPasswordURL + "/$email", headers: header);
    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteUserByID(
      String jwt, int userID, String password) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var p = utf8.encode(password);
    Digest sh = sha1.convert(p);
    String _password = sh.toString();
    var map = Map();
    map['id'] = userID;
    map['password'] = _password;
    var putBody = json.encode(map);
    var res = await http.post(userDatasURL + "/deleteUser",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);

    if (res.body == "true")
      return true;
    else
      return false;
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

  static Future<double> getUserRating(String jwt, int userID) async {
    String userRating = userDatasURL + "/userRating";
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    print("URL");
    print(userRating + "/$userID");
    var res = await http.get(userRating + "/$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    return double.parse(res.body);
  }
}
