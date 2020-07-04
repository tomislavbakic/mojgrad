class Post {
  int _id;
  int _userDataID;
  String _title;
  String _description;
  int _categoryID;
  DateTime _time;
  int _active;
  String _postImage;
  String _address;
  int _city;
  double _latitude;
  double _longitute;

  Post(
      this._userDataID,
      this._title,
      this._description,
      this._categoryID,
      this._time,
      this._active,
      this._postImage,
      this._address,
      this._city,
      this._latitude,
      this._longitute);

  int get id => _id;
  int get userID => _userDataID;
  String get title => _title;
  String get description => _description;
  int get categoryID => _categoryID;
  DateTime get time => _time;
  bool get isActive {
    if (_active == 1)
      return true;
    else
      return false;
  }

  String get postImage => _postImage;
  String get address => _address;
  double get latitude => _latitude;
  double get longitude => _longitute;
  int get city => _city;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["userdataid"] = _userDataID;
    map["title"] = _title;
    map["description"] = _description;
    map["categoryid"] = _categoryID;
    map["time"] = _time.toIso8601String();
    map["active"] = _active;
    map["postImage"] = _postImage;
    map["cityID"] = _city;
    map["address"] = _address;
    map["latitude"] = _latitude;
    map["longitude"] = _longitute;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Post.fromObject(dynamic o) {
    int idPom = o["id"];
    //parsing datetime
    DateTime datePom = DateTime.tryParse(o["time"]);
    //print(datePom);
    this._id = idPom;
    this._userDataID = o["userdataid"];
    this._title = o["title"];
    this._description = o["description"];
    this._categoryID = o["categoryid"];
    this._time = datePom;
    this._active = o["active"];
    this._postImage = o["postImage"];
    this._longitute = o["longitude"];
    this._latitude = o["longitude"];
    this._city = o["cityID"];
    this._address = o["address"];
  }
}
