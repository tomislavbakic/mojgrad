import 'dart:convert';

class City {
  int _id;
  String _name;

  City(id, name) {
    this._id = id;
    this._name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
    };
  }

  String get name => _name;
  int get id => _id;
 

  City.fromObject(dynamic map) {
    this._id = map['id'];
    this._name = map['name'];
  }

  String toJson() => json.encode(toMap());

  static City fromJson(String source) => City.fromObject(json.decode(source));
}
