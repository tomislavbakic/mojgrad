import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/admin.dart';
import 'package:webproject/models/rank.dart';
import 'package:webproject/models/view/adminInfo.dart';
import 'package:webproject/models/view/categoryView.dart';
import 'package:webproject/models/view/city.dart';
import 'package:webproject/models/view/feedback.dart';
import 'package:webproject/models/view/genderInfo.dart';
import 'package:webproject/models/view/metric.dart';
import 'package:webproject/models/view/ranksInfo.dart';
import 'package:webproject/models/view/rate.dart';
import 'package:webproject/models/view/statisticInfo.dart';

class APIServices {
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

//email forrmat
  static bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }

  static int validatePassword(String value) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    // should contain at least one upper case
    // should contain at least one lower case
    // should contain at least one digit
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return 0;
    } else {
      if (!regex.hasMatch(value))
        return 0;
      else
        return 1;
    }
  }

  static Future<List<FeedbackInfo>> fetchAllFeedbacks(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(feedbackURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<FeedbackInfo> feedbackList = new List<FeedbackInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        feedbackList.add(FeedbackInfo.fromObject(item));
      }
      return feedbackList;
    }
    return null;
  }

  static Future<List<AdminInfo>> getAllAdminsInfo(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(adminURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<AdminInfo> admins = List<AdminInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        admins.add(AdminInfo.fromObject(item));
      }
      return admins;
    }

    return null;
  }

  static Future<bool> addNewAdministrator(String jwt, Admin admin) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var postBody = jsonEncode(admin.toMap());
    var response = await http.post(adminURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);
    if (response.body == "true")
      return true;
    else {
      return false;
    }
  }

  static Future<bool> addNewRank(String jwt, Rank newRank) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var postBody = jsonEncode(newRank.toMap());
    Response response = await post(ranksURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);
    if (response.body == "true")
      return true;
    else
      return false;
  }

  static Future<List<RanksInfo>> getAllRanks(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(ranksURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<RanksInfo> list = new List<RanksInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(RanksInfo.fromObject(item));
      }
      return list;
    }
    return null;
  }

  static Future<List<City>> getAllCities(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(cityURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<City> cities = new List<City>();
    cities.add(City(-1, "Svi gradovi"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        cities.add(City.fromObject(item));
      }
      return cities;
    }
    return null;
  }

  static Future<List<CategoryView>> getAllCategories(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(categoryURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<CategoryView> category = new List<CategoryView>();
    category.add(CategoryView(-1, "Sve kategorije"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        category.add(CategoryView.fromObject(item));
      }
      return category;
    }
    return null;
  }

  //upload image to server
  static Future<String> addImageWeb(String img, String route) async {
    var url = imageUploadWebURL;
    var map = Map();
    map['img'] = img;
    map['route'] = route;
    var putBody = json.encode(map);
    var res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: putBody);
    return res.body;
  }

  static Future<Rate> getAplicationRate(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(rateURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    Rate rate;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      rate = Rate.fromObject(data);
      return rate;
    }

    return null;
  }

  static Future<List<StatisticInfo>> getAllStatisticInfo(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(percentageURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<StatisticInfo> info = List<StatisticInfo>();
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        info.add(StatisticInfo.fromObject(item));
      }
      return info;
    }
    return null;
  }

  static Future<Metric> getMetricInfo(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(
      adminURL + "/getStatistics",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );
    Metric metric;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      metric = Metric.fromObject(data);
      return metric;
    }
    return null;
  }

  static Future<GenderInfo> getGenderInfo(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(adminURL + "/genderStats", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    GenderInfo genderInfo;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      genderInfo = GenderInfo.fromObject(data);
      return genderInfo;
    }
    return null;
  }

  static Future<bool> deleteLastRank(String jwt, int rankID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http.delete(ranksURL + "/$rankID", headers: {
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

  static Future<bool> deleteAdminByUsername(String jwt, String username) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response =
        await http.delete(adminURL + "/deleteadmin/$username", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    print(response.statusCode);
    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }
}
