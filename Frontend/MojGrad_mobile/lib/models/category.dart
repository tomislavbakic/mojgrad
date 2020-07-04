class Category {
  int _id;
  String _name;

  Category(this._name);

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

  Category.fromObject(dynamic o) {
    int idPom = o["id"];
    
    this._id = idPom;
    this._name = o["name"];
  }

  
  static List encondeToJson(List<Category>list){
    List jsonList = List();
    list.map((item)=>
      jsonList.add(item.toMap())
    ).toList();
    return jsonList;
}
}
