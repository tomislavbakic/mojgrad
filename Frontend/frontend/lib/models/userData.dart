
class UserData {
  int _id;
  String _email;
  String _password;
  String _name;
  String _lastname;
  int _cityID;
  int _eko;
  int _rankID;
  String _photo;
  
  String get email => _email;
  String get name => _name;
  String get lastname => _lastname;
  int get cityID => _cityID;
  int get eko => _eko;
  int get rankID => _rankID;
  String get photo => _photo;

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
    print(value);
    if (value.isEmpty) {
      return 0;
    } else {
      if (!regex.hasMatch(value))
        return 0;
      else
        return 1;
    }
  }

  UserData(name, lastname, password, email, cityId) {
    this._name = name;
    this._lastname = lastname;
    this._password = password;
    this._email = email;
    this._cityID = cityId;
    this._eko = 0;
    this._rankID = 1;
    this._photo = "Upload//UserProfile//default.jpg";
  }

  UserData.id(id, name, lastname, password, email, cityId) {
    this._id = id;
    this._name = name;
    this._lastname = lastname;
    this._password = password;
    this._email = email;
    this._cityID = cityId;
    this._eko = 0;
    this._rankID = 1;
    this._photo = "Upload//UserProfile//default.jpg";
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['name'] = _name;
    map['lastname'] = _lastname;
    map['password'] = _password;
    map['email'] = _email;
    map['cityID'] = _cityID;
    map['eko'] = _eko;
    map['rankID'] = _rankID;
    map['photo'] = _photo;
    return map;
  }

  UserData.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._lastname = o['lastname'];
    this._password = o['password'];
    this._email = o['email'];
    this._cityID = o['cityID'];
    this._eko = o['points'];
    this._rankID = o['rankID'];
    this._photo = o['photo'];
  }


}
