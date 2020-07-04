
class Feedbacks {
  int id;
  int userID;
  String text;

  int get getUserID => userID;
  set setUserID(int userID) => this.userID = userID;
  String get getText => text;
  set setText(String text) => this.text = text;

  Feedbacks(userID, text) {
    this.userID = userID;
    this.text = text;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["userDataID"] = userID;
    map["text"] = text;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Feedbacks.fromObject(dynamic o) {
    this.text = o['text'];
    this.userID = o['userDataID'];
  }


  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
