import 'dart:convert';
import 'package:fronend/config/config.dart'; //config file for URL
import 'package:fronend/models/category.dart';
import 'package:fronend/models/view/city.dart';
import 'package:fronend/models/view/notificationInfo.dart';
import 'package:http/http.dart' as http;

class APIServices {
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //fetch all categories from database
  static Future<List<Category>> fetchAllCategories(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(categoryURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<Category> categoryList = new List<Category>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var category in data) {
        categoryList.add(Category.fromObject(category));
      }
      return categoryList;
    }
    return null;
  }

  //get all cities from db
  static Future<List<City>> getAllCities(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http.get(cityURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<City> cityList = new List<City>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        cityList.add(City.fromObject(post));
      }
      return cityList;
    }
    return null;
  }

  static Future<void> rateMyApp(String jwt, int userID, int grade) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['userDataID'] = userID;
    map['grade'] = grade;
    var postBody = jsonEncode(map);
    http.Response response = await http.post(rateMyAppURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);
  }

  static Future<List<NotificationInfo>> getAllNotificationForUserID(
      String jwt, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response =
        await http.get(notificationURL + "/$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<NotificationInfo> notificationList = new List<NotificationInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        notificationList.add(NotificationInfo.fromObject(item));
      }
      return notificationList;
    }
    return null;
  }
}
