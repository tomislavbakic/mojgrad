class AdminInfo {
  String _username;
  int _isHead;

  bool get isHead {
    if (_isHead == 1)
      return true;
    else
      return false;
  }

  String get username => _username;

  AdminInfo(username, head) {
    this._username = username;
    this._isHead = head;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['username'] = _username;
    map['head'] = _isHead;
    return map;
  }

  AdminInfo.fromObject(dynamic o) {
    this._username = o['username'];
    this._isHead = o['head'];
  }
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
}
