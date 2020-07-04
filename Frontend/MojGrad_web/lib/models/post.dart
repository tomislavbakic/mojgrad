class Post {
  int _id;
  int _userID;
  String _title;
  String _description;
  int _categoryID;
  DateTime _time;
  String _location;
  String _priority;

  Post(this._userID, this._title, this._description, this._categoryID,
      this._time, this._location, this._priority);

  Post.OnlyDescription(this._description);

  int get id => _id;
  int get userID => _userID;
  String get title => _title;
  String get description => _description;
  int get categoryID => _categoryID;
  DateTime get time => _time;
  String get location => _location;
  String get priority => _priority;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["userdataid"] = _userID;
    map["title"] = _title;
    map["description"] = _description;
    map["categoryid"] = _categoryID;
    map["time"] = _time.toIso8601String();
    map["location"] = _location;
    map["priority"] = _priority;

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
    this._userID = o["userdataid"];
    this._title = o["title"];
    this._description = o["description"];
    this._categoryID = o["categoryid"];
    this._time = datePom;
    this._location = o["location"];
    this._priority = o["priority"];
  }
}
