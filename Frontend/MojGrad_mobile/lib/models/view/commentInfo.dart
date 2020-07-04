import 'dart:convert';

class CommentView {
  int _id;
  String _fullName;
  String _userPhoto;
  String _text;
  String _commentPhoto;
  int _userID;
  int _likesNumber;
  int _dislikesNumber;
  int _isLikedOrDisliked; // 1 liked       0 neutral       -1 disliked
  int _awarded;
  int _postID;
  int _postActive;

  bool get isLikedComment {
    if (_isLikedOrDisliked == 1)
      return true;
    else
      return false;
  }

  bool get isDislikedComment {
    if (_isLikedOrDisliked == -1)
      return true;
    else
      return false;
  }

  bool get isAwarded {
    if (_awarded == 1)
      return true;
    else
      return false;
  }

  bool get isPostActive{
    if(_postActive == 1)
      return true;
      else 
      return false;
  }

  int get postID => _postID;
  int get userCommentID => _userID;
  int get id => _id;
  String get fullName => _fullName;
  String get text => _text;
  String get commentPhoto => _commentPhoto;
  set imageURL(String value) => _commentPhoto = value;
  int get likesNumber => _likesNumber;
  get dislikesNumber => _dislikesNumber;
  String get userPhoto => _userPhoto;
  int get isLikedOrDisliked => _isLikedOrDisliked;

  CommentView(id, text, userPhoto, fullName, imageURL, likes, dislikes,
      likeOrDislike, userDataID,awarded,postID,postActive) {
    this._id = id;
    this._text = text;
    this._fullName = fullName;
    this._commentPhoto = imageURL;
    this._likesNumber = likes;
    this._dislikesNumber = dislikes;
    this._userPhoto = userPhoto;
    this._isLikedOrDisliked = likeOrDislike;
    this._userID = userDataID;
    this._awarded = awarded;
    this._postID = postID;
    this._postActive = postActive;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'text': _text,
      'fullName': _fullName,
      'commentPhoto': _commentPhoto,
      'likesNumber': _likesNumber,
      'dislikesNumber': _dislikesNumber,
      'userPhoto': _userPhoto,
      'isLikedOrDisliked': _isLikedOrDisliked,
      'userDataID': _userID,
      'awarded': _awarded,
      'postID' :_postID,
      'postActive': _postActive,
    };
  }

  CommentView.fromObject(dynamic map) {
    this._id = map['id'];
    this._text = map['text'];
    this._fullName = map['fullName'];
    this._commentPhoto = map['commentPhoto'];
    this._likesNumber = map['likesNumber'];
    this._dislikesNumber = map['dislikesNumber'];
    this._userPhoto = map['userPhoto'];
    this._isLikedOrDisliked = map['isLikedOrDisliked'];
    this._userID = map['userDataID'];
    this._awarded = map['awarded'];
    this._postID = map['postID'];
    this._postActive = map['postActive'];
  }

  String toJson() => json.encode(toMap());

  static CommentView fromJson(String source) =>
      CommentView.fromObject(json.decode(source));
}
