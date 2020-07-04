import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/organisation.dart';
import 'package:webproject/models/postOrg.dart';
import 'package:webproject/models/view/organisationView.dart';
import 'package:webproject/models/view/postOrgView.dart';
import 'package:crypto/crypto.dart';

class APIServicesOrg {
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future<bool> orgChangeName(String jwt, int id, String name) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = id;
    map['name'] = name;
    var putBody = json.encode(map);
    http.Response response = await http.put(organisationURL + "/changeOrgData",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> orgChangeEmail(String jwt, int id, String email) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = id;
    map['email'] = email;
    var putBody = json.encode(map);
    http.Response response = await http.put(organisationURL + "/changeOrgData",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> orgChangePlace(String jwt, int id, String place) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = id;
    map['location'] = place;
    var putBody = json.encode(map);
    http.Response response = await http.put(organisationURL + "/changeOrgData",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> orgChangePhoto(String jwt, int id, String photo) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var map = Map();
    map['id'] = id;
    map['imagePath'] = photo;
    var putBody = json.encode(map);
    http.Response response = await http.put(organisationURL + "/changeOrgData",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<bool> orgChangePassword(
      String jwt, int id, String pass1, String pass2) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['id'] = id;
    map['oldPassword'] = pass1;
    map['newPassword'] = pass2;
    var putBody = json.encode(map);
    http.Response response = await http.put(organisationURL + "/changeOrgPass",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: putBody);
    if (response.body == "true")
      return true;
    else
      return false;
  }

  static Future<OrganisationView> getOrganisationsDataByID(
      String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var response = await http.get(
      organisationURL + "/$id",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    OrganisationView org;
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      org = OrganisationView.fromObject(data);
      return org;
    }
    return null;
  }

  static Future<bool> newPostFromOrganisation(String jwt, PostOrg post) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var postBody = jsonEncode(post.toMap());
    var response = await http.post(organisationPostsURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);
    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<OrganisationView>> fetchAllOrganisation(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(organisationURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<OrganisationView> list = new List<OrganisationView>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(OrganisationView.fromObject(item));
      }
      return list;
    }
    return null;
  }

  static Future<List<OrganisationView>> fetchUnverifiedOrganisation(
      String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(organisationURL + "/unverified", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<OrganisationView> list = new List<OrganisationView>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(OrganisationView.fromObject(item));
      }
      return list;
    }
    return null;
  }

  static Future<bool> verificateOrganisationByID(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var res = await post(verificateOrganisationURL + "/$id", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<List<PostOrgView>> getAllOrganisationsPosts(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(organisationPostsURL + "/userid=1", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostOrgView> list = new List<PostOrgView>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(PostOrgView.fromObject(item));
      }
      return list;
    }
    return null;
  }

  static Future<bool> deleteOrganisationAdminByID(String jwt, int orgID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response =
        await http.delete(adminURL + "/deleteOrganisation/$orgID", headers: {
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

  static Future<String> checkOrg(String email, String password) async {
    var data = Map();
    data['email'] = email;
    data['password'] = password;
    var jsonBody = jsonEncode(data);

    var res =
        await http.post(organisationLoginURL, headers: header, body: jsonBody);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  static Future<String> checkEmail(String email) async {
    String url = organisationCheckURL;
    var data = Map();
    data['email'] = email;
    var jsonBody = jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data_2 = res.body.toString();
    return data_2;
  }

  static Future<int> registrationOrganisation(Organisation org) async {
    String url = organisationURL;
    var data = org.toMap();
    var jsonBody = jsonEncode(data);
    var email = (await checkEmail(org.email)).toString();
    if (email == "true")
      return 0;
    else {
      var res = await http.post(url, headers: header, body: jsonBody);
      return res.statusCode;
    }
  }

  static Future<bool> deleteOrgByID(
      String jwt, int orgID, String password) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var p = utf8.encode(password);
    Digest sh = sha1.convert(p);
    String _password = sh.toString();
    var map = Map();
    map['id'] = orgID;
    map['password'] = _password;
    var putBody = json.encode(map);
    var res = await http.post(organisationURL + "/deleteOrg",
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
}
