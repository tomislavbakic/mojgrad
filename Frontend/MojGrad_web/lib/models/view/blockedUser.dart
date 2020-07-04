import 'dart:convert';

class BlockedUser {
  int _id;
 // int _userID;
  String _reason;
  String _fullname;
  String _blockedUntil;
  String _photo;

  int get id => _id;
  //int get userID => _userID;
  String get reason => _reason;
  String get fullname => _fullname;
  String get photo => _photo;
  BlockedUser( userID, reason, fullname, blockedUntil,photo) {
  //  this._id = id;
    this._id = userID;
    this._reason = reason;
    this._fullname = fullname;
    this._blockedUntil = blockedUntil;
    this._photo = photo;
  }

  Map<String, dynamic> toMap() {
    return {
    //  'id': _id,
      'userID': _id,
      'reason': _reason,
      'fullname': _fullname,
      'blockedUntil': _blockedUntil,
      'photo' : _photo,
    };
  }

  BlockedUser.fromObject(dynamic map) {
   // this._id = map['id'];
    this._id = map['userID'];
    this._reason = map['reason'];
    this._fullname = map['fullname'];
    this._blockedUntil = map['blockedUntil'];
    this._photo = map['photo'];
  }

  String toJson() => json.encode(toMap());

  static BlockedUser fromJson(String source) =>
      BlockedUser.fromObject(json.decode(source));
}
