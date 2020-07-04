class Admin {
  int _id;
  String _username;
  String _password;

  Admin(username, password) {
    _username = username;
    _password = password;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['username'] = _username;
    map['password'] = _password;

    return map;
  }

  Admin.fromObject(dynamic o) {
    this._id = o['id'];
    this._username = o['username'];
    this._password = o['password'];
  }
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
