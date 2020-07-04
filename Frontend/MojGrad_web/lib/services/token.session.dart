import 'dart:html';

class Token {
  static set setToken(String value) => window.sessionStorage["jwt"] = value;
  static String get getToken => window.sessionStorage["jwt"];
  static set deleteToken(String value) => window.sessionStorage["jwt"] = "";
}
