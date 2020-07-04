import 'dart:convert';

class ChangePostModel
{
  int _postID;
  String _title;
  String  _description;
  String _postImage;

  ChangePostModel(postID,title,description,imagePath)
  {
    this._postID = postID;
    this._title = title;
    this._description = description;
    this._postImage = imagePath;
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': _postID,
      'Title': _title,
      'Description': _description,
      'imageURL': _postImage,
    };
  }

  ChangePostModel.fromObject(dynamic map) {
    _postID = map['ID'];
    _title = map['Title'];
    _description = map['Description'];
    _postImage = map['imageURL'];
  }

   String toJson() => json.encode(toMap());
}