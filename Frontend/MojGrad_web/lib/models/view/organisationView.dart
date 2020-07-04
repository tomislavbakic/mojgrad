import 'dart:convert';

class OrganisationView {
  int _id;
  String _name;
  String _email;
  String _phone;
  String _activity;
  String _location;
  String _photo;
  int _verification;

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get activity => _activity;
  String get location => _location;
  String get photo => _photo;

  bool get isVerificated {
    if (_verification == 1)
      return true;
    else
      return false;
  }

  OrganisationView(
      id, name, email, phone, activity, location, photo, verification) {
    _id = id;
    _name = name;
    _email = email;
    _phone = activity;
    _location = location;
    _photo = photo;
    _activity = activity;
    _verification = verification;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'phoneNumber': _phone,
      'activity': _activity,
      'photo': _photo,
      'email': _email,
      'location': _location,
      'verification': _verification,
    };
  }

  OrganisationView.fromObject(dynamic map) {
    this._id = map['id'];
    this._activity = map['activity'];
    this._photo = map['photo'];
    this._email = map['email'];
    this._phone = map['phoneNumber'];
    this._location = map['location'];
    this._name = map['name'];
    this._verification = map['verification'];
  }

  String toJson() => json.encode(toMap());

  static OrganisationView fromJson(String source) =>
      OrganisationView.fromObject(json.decode(source));
}
