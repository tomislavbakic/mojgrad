class Organisation {
  String _name;
  String _password;
  String _phoneNumber;
  String _activity;
  String _location;
  String _email;
  int _verification;
  Organisation(name, email, location, phoneNumber, activity, password) {
    this._name = name;
    this._email = email;
    this._password = password;
    this._phoneNumber = phoneNumber;
    this._activity = activity;
    this._location = location;
    this._verification = 0;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    map['phoneNumber'] = _phoneNumber;
    map['activity'] = _activity;
    map['location'] = _location;
    map['verification'] = _verification;
    return map;
  }

  Organisation.fromObject(dynamic o) {
    this._name = o['name'];
    this._email = o['email'];
    this._password = o['password'];
    this._activity = o['activity'];
    this._phoneNumber = o['phoneNumber'];
    this._location = o['location'];
    this._verification = o['verification'];
  }
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  String get email => _email;
  String get name => _name;
  String get activity => _activity;
  String get location => _location;
  String get phoneNumber => _phoneNumber;
}
