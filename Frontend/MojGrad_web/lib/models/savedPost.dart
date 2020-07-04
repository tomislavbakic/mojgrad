import 'dart:convert';

class SavedPost
{
  int _organisationID;
  int _postID;

  SavedPost(orgID,postID)
  {
    this._organisationID = orgID;
    this._postID = postID;
  }
Map<String, dynamic> toMap() {
    return {
      "postID": _postID,
      "organisationID": _organisationID,
    };
  }

  SavedPost.fromObject(dynamic map) {
    this._organisationID = map["organisationID"];
    this._postID = map["postID"];
   
  }

  String toJson() => json.encode(toMap());

  static SavedPost fromJson(String source) =>
      SavedPost.fromObject(json.decode(source));
}