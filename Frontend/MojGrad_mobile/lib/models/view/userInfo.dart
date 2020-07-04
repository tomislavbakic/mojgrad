//this class is for data from API, contain all user data

class UserInfo {
  int _id;
  String _name;
  String _lastname;
  String _email;
  int _eko;
  int _cityID;
  int _rankID;
  String _cityName;
  String _rankName;
  int _postsNumber;
  int _commentsNumber;
  String _photo;
  String _rankImage;
  String _gender;
  int _age;
  int _isBlocked;

  UserInfo(name, lastname, email, eko, cityID, rankID, cityName, rankName,
      postNum, commNum, photo, rankImage, isBlocked) {
    this._name = name;
    this._lastname = lastname;
    this._email = email;
    this._cityID = cityID;
    this._eko = eko;
    this._rankID = rankID;
    this._cityID = cityID;
    this._cityName = cityName;
    this._postsNumber = postNum;
    this._commentsNumber = commNum;
    this._photo = photo;
    this._rankImage = rankImage;
    this._isBlocked = isBlocked;
  }
  UserInfo.id(id, name, lastname, email, eko, cityID, rankID, cityName,
      rankName, postNum, commNum, photo, rankImage, isBlocked) {
    this._id = id;
    this._name = name;
    this._lastname = lastname;
    this._email = email;
    this._cityID = cityID;
    this._eko = eko;
    this._rankID = rankID;
    this._cityID = cityID;
    this._cityName = cityName;
    this._postsNumber = postNum;
    this._commentsNumber = commNum;
    this._photo = photo;
    this._rankImage = rankImage;

    this._isBlocked = isBlocked;
  }

//geters
  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get lastname => _lastname;
  int get cityID => _cityID;
  int get eko => _eko;
  int get rankID => _rankID;
  String get cityName => _cityName;
  String get rankName => _rankName;
  int get postsNumber => _postsNumber;
  int get commentsNumber => _commentsNumber;
  String get photo => _photo;
  String get rankImage => _rankImage;
  int get age => _age;
  String get gender => _gender;
  String get fullname => _name + " " + _lastname;

  bool get isBlocked {
    if (_isBlocked == 1)
      return true;
    else
      return false;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['name'] = _name;
    map['lastname'] = _lastname;
    map['email'] = _email;
    map['cityID'] = _cityID;
    map['eko'] = _eko;
    map['rankID'] = _rankID;
    map['cityName'] = _cityName;
    map['rankName'] = _rankName;
    map['postsNumber'] = _postsNumber;
    map['commentsNumber'] = _commentsNumber;
    map['photo'] = _photo;
    map['rankImage'] = _rankImage;
    map['gender'] = _gender;
    map['age'] = _age;
    map['isBlocked'] = _isBlocked;
    return map;
  }

  UserInfo.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._lastname = o['lastname'];
    this._email = o['email'];
    this._cityID = o['cityID'];
    this._eko = o['eko'];
    this._rankID = o['rankID'];
    this._rankName = o['rankName'];
    this._cityName = o['cityName'];
    this._postsNumber = o['postsNumber'];
    this._commentsNumber = o['commentsNumber'];
    this._rankImage = o['rankImage'];
    this._photo = o['photo'];
    this._gender = o['gender'];
    this._age = o['age'];
    this._isBlocked = o['isBlocked'];
  }
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
