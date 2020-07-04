import 'dart:convert';

class ReportedCommentView {
  int _id;
  String _description; //report
  String _userPhoto;
  String _commentText;
  String _commentPhoto;
  int _commentID;
  String _userFullname;
  int _userDataID;
  int _postID;
  int _isBlocked;

  bool get isBlocked {
    if (_isBlocked == 1)
      return true;
    else
      return false;
  }

  set block(bool react) {
    if (react == true) {
      _isBlocked = 1;
    } else
      _isBlocked = 0;
  }

  int get id => _id;
  String get description => _description; //report

  String get commentText => _commentText;
  String get commentPhoto => _commentPhoto;
  int get commentID => _commentID;
  String get userFullname => _userFullname;
  int get userDataID => _userDataID;
  int get postID => _postID; //ovo je bilo zakomentarisano
  String get userPhoto => userPhoto; //i ovo isto

  ReportedCommentView(id, desc, text, commPhoto, commID, userName, userID,
      userPhoto, postID, isBlocked) {
    _id = id;
    _description = desc;
    _commentPhoto = commPhoto;
    _commentText = text;
    _commentID = commID;
    _userFullname = userName;
    _userDataID = userID;
    _userPhoto = userPhoto;
    _isBlocked = isBlocked;
    _postID = postID;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "description": _description,
      "commentID": _commentID,
      "userDataID": _userDataID,
      "userFullname": _userFullname,
      "commentText": _commentText,
      "commentPhoto": _commentPhoto,
      "postID": _postID,
      "isBlocked": _isBlocked,
      "userPhoto": _userPhoto,
    };
  }

  ReportedCommentView.fromObject(dynamic map) {
    this._id = map['id'];
    this._description = map['description'];
    this._commentID = map['commentID'];
    this._commentPhoto = map['commentPhoto'];
    this._userFullname = map['userFullname'];
    this._userDataID = map['userDataID'];
    this._userPhoto = map['userPhoto'];
    this._commentText = map['commentText'];
    this._postID = map['postID'];
    this._isBlocked = map['isBlocked'];
    this._userPhoto = map["userPhoto"];
  }

  String toJson() => json.encode(toMap());

  static ReportedCommentView fromJson(String source) =>
      ReportedCommentView.fromObject(json.decode(source));
}
