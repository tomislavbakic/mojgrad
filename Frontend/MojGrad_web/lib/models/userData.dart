//import 'dart:convert' as convert;
//import 'package:http/http.dart' as http;

class UserData {
  int _id;
  String _email;
  String _password;
  //String _password2;
  String _name;
  String _lastname;
  String _cityName;
  int _eko;
  String _rankName;

/*
  testirati ovaj pattern
  [a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?

*/
  //email forrmat
  static bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  UserData(name, lastname, password, email, cityName, rankName) {
    this._name = name;
    this._lastname = lastname;
    this._password = password;
    this._email = email;
    this._cityName = cityName;
    this._eko = 0;
    this._rankName = rankName;
  }

  UserData.id(id, name, lastname, password, email, cityName, rankName) {
    this._id = id;
    this._name = name;
    this._lastname = lastname;
    this._password = password;
    this._email = email;
    this._cityName = cityName;
    this._eko = 0;
    this._rankName = rankName;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['name'] = _name;
    map['lastname'] = _lastname;
    map['password'] = _password;
    map['email'] = _email;
    map['cityName'] = _cityName;
    map['eko'] = _eko;
    map['rankName'] = _rankName;
    return map;
  }

  UserData.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._lastname = o['lastname'];
    this._password = o['password'];
    this._email = o['email'];
    this._cityName = o['cityName'];
    this._eko = o['points'];
    this._rankName = o['rankName'];
  }
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  String get email => _email;
  String get name => _name;
  String get lastname => _lastname;
  String get cityName => _cityName;
  int get eko => _eko;
  String get rankName => _rankName;

/*  static Future<UserData> fetchUserDataByID(int id) async {
    String url = userDatasURL + "/$id";
    print(url);
    var res = await http.get(url, headers: header);
    var data = convert.jsonDecode(res.body);

    UserData userData = UserData.fromObject(data);

    print(userData._email);
    print(res.body);

    return userData;
  }*/

/*
  String toJson() => json.encode(toMap());

  static UserData fromJson(String source) =>
      UserData.fromObject(json.decode(source));

  static Future<List<UserData>> fetchAllUsers(String jwt) async {
    print(jwt);

    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    print("URL POSTOVA:$userDatasURL");
    Response response = await get(userDatasURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<UserData> userList = new List<UserData>();
    print("STATUS ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (var post in data) {
        userList.add(UserData.fromObject(post));
      }
      print(userList);
      return userList;
    }
    return null;
  }
*/
  /*
  static Future<String> checkUser(String email, String password) async {
    String url = loginURL;

    var data = Map();
    data['email'] = email;
    data['password'] = password;

    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: header, body: jsonBody);

    if (res.statusCode == 200) return res.body;
    print(res.statusCode);
    return null;
  }

  static Future<String> checkEmail(String email) async {
    String url = emailURL;

    var data = Map();
    data['email'] = email;
    var jsonBody = convert.jsonEncode(data);
    //  print(jsonBody);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data_2 = res.body.toString();
    // print(data_2);
    return data_2;
  }

  static Future<int> registration(UserData user) async {
    String url = userDatasURL;
    var data = user.toMap();
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var email = (await checkEmail(user._email)).toString();
    if (email == "true")
      return 0;
    else {
      var res = await http.post(url, headers: header, body: jsonBody);
      print(res);
      print(res.statusCode);
      return res.statusCode;
    }
  }*/
}
