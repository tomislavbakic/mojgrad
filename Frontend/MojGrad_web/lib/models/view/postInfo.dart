import 'dart:convert';

class PostInfo {
  int _id;
  String _title;
  String _description;
  String _address;
  String _city;
  //DateTime _time;
  String _time;
  double _latitude;
  double _longitude;
  String _fullname;
  int _commentsNumber;
  int _likesNumber;
  int _active;
  String _categoryName;
  String _userPhoto;
  String _postImage;
  int _isLiked;
  int _userID;
  int _isSaved;

  bool get isSaved {
    if (this._isSaved == 1)
      return true;
    else
      return false;
  }

  bool get isLiked {
    if (this._isLiked == 1)
      return true;
    else
      return false;
  }

  bool get isActive {
    if (_active == 1)
      return true;
    else
      return false;
  }

  String get userPhoto => _userPhoto;
  String get postImage => _postImage;
  set userPhoto(String userPhoto) => this._userPhoto = userPhoto;
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get address => _address;
  String get time => _time;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get fullname => _fullname;
  int get commentsNumber => _commentsNumber;
  int get likesNumber => _likesNumber;

  String get categoryName => _categoryName;
  String get getCategoryName => categoryName;
  int get userID => _userID;
  String get city => _city;

  PostInfo(
      id,
      title,
      description,
      categoryName,
      address,
      fullname,
      active,
      commentsNum,
      likesNum,
      time,
      userPhoto,
      postImage,
      isLiked,
      userID,
      latitude,
      longitude,
      city,
      isSaved) {
    this._id = id;
    this._address = address;
    this._description = description;
    this._fullname = fullname;
    this._active = active;
    this._commentsNumber = commentsNum;
    this._likesNumber = likesNum;
    this._title = title;
    this._time = time;
    this._categoryName = categoryName;
    this._userPhoto = userPhoto;
    this._postImage = postImage;
    this._isLiked = isLiked;
    this._userID = userID;
    this._latitude = latitude;
    this._longitude = longitude;
    this._city = city;
    this._isSaved = isSaved;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': _title,
      'description': _description,
      'time': _time,
      'address': _address,
      'fullName': _fullname,
      'commentsNumber': _commentsNumber,
      'likesNumber': _likesNumber,
      'active': _active,
      'categoryName': _categoryName,
      'userPhoto': _userPhoto,
      'postImage': _postImage,
      'isLiked': _isLiked,
      'userID': _userID,
      'city': _city,
      'latitude': _latitude,
      'longitude': _longitude,
      'isSaved': _isSaved,
    };
  }

  PostInfo.fromObject(dynamic map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _time = map['time'];
    _address = map['address'];
    _fullname = map['fullName'];
    _commentsNumber = map['commentsNumber'];
    _likesNumber = map['likesNumber'];
    _categoryName = map['categoryName'];
    _active = map['active'];
    _userPhoto = map['userPhoto'];
    _postImage = map['postImage'];
    _isLiked = map['isLiked'];
    _userID = map['userID'];
    _city = map['city'];
    _latitude = map['latitude'];
    _longitude = map['longitude'];
    _isSaved = map['isSaved'];
  }

  String toJson() => json.encode(toMap());

  static PostInfo fromJson(String source) =>
      PostInfo.fromObject(json.decode(source));
}
