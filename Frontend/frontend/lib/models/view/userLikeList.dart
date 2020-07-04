
class UserLike {
  int _id;
  String _name;
  String _lastname;
  String _email;
  String _photo;
  int _eko;

  int get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get email => _email;
  String get photo => _photo;
  int get eko => _eko;

  UserLike(id,name,lastname,email,photo,eko)
  {
    this._eko = eko;
    this._email = email;
    this._id = id;
    this._photo = photo;
    this._name = name;
    this._lastname = lastname;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'photo': _photo,
      'name': _name,
      'lastname': _lastname,
      'email': _email,
      'eko' : _eko,
    };
  }

  UserLike.fromObject(dynamic map) {
    this._id = map['id'];
    this._name = map['name'];
    this._lastname = map['lastname'];
    this._email = map['email'];
    this._eko = map['eko'];
    this._photo = map['photo'];
  }

}
