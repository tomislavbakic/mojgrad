class CategoryView {
  int _id;
  String _name;

  CategoryView(this._id,this._name);

  int get id => _id;
  String get name => _name;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  CategoryView.fromObject(dynamic o) {
    int idPom = o["id"];
    
    this._id = idPom;
    this._name = o["name"];
  }
}
