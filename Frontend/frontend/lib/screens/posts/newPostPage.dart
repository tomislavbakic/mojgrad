import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/bottomNavigationBar.dart';
import 'package:fronend/functions/images.dart';
import 'package:fronend/functions/maps.dart';
import 'package:fronend/functions/uploadingDialog.dart';
import 'package:fronend/models/category.dart';
import 'package:fronend/models/post.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/services/api.services.dart';
import 'package:fronend/services/api.services.posts.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as gps;
import 'package:path/path.dart';
import '../../main.dart';
import 'package:fronend/config/config.error.dart';

Color boja = Colors.green;

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  int userID = LoggedUser.id; //logged user
  String postTitle;
  String postDesctiption;
  int category;
  DateTime time;
  String location;
  int active = 1;
  String address = "";
  String city = "";
  double latitude = 0.0;
  double longitude = 0.0;
  File _image;
  int _locationFlag = 0;
  //geolocator
  Geolocator get geolocator => Geolocator()..forceAndroidLocationManager;
  var locationPermission = gps.Location();
  //server url

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  Position _currentPosition;
  String _currentAddress = "";

  Category _currentCategory;
  List<Category> categories;

  TextEditingController _streetAddress = new TextEditingController();
  TextEditingController _townAddress = new TextEditingController();

  //dropdown
  Widget buildDropdownButton() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<Category>>(
              future: APIServices.fetchAllCategories(globalJWT),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Category>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<Category>(
                  items: snapshot.data
                      .map((categoryy) => DropdownMenuItem<Category>(
                            child: Text(categoryy.name),
                            value: categoryy,
                          ))
                      .toList(),
                  onChanged: (Category value) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      _currentCategory = value;
                    });
                  },
                  value: _currentCategory == null
                      ? _currentCategory
                      : snapshot.data
                          .where((element) =>
                              element.name == _currentCategory.name)
                          .first,
                  isExpanded: false,
                  //value: _currentUser,
                  hint: Text('Kategorija'),
                );
              }),
          _currentCategory != null
              ? _currentCategory.name == "Lepša strana grada"
                  ? Text("*Izabrali ste običnu objavu.",
                      style: TextStyle(color: Colors.grey))
                  : Text("*Izabrali ste izazov.",
                      style: TextStyle(color: Colors.grey))
              : Container(),
          SizedBox(height: 10),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldstate,
        resizeToAvoidBottomPadding: false,
        appBar: buildAppBar(context),
        body: buildBody(context),
        bottomNavigationBar: MyBottomNavigationBar(2),
      ),
    );
  }

  //appBar construction
  Widget buildAppBar(context) {
    return AppBar(
      title: Text("Nova objava"),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.check, size: 30),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (LoggedUser.data.isBlocked == true) {
              _showSnakBar3sec(blockedAccountMSG);
            } else {
              if (postTitle == null || postTitle == "") {
                _showSnakBarMsg(titleMissingMSG);
              } else if (_currentAddress == null ||
                  _currentAddress == "" ||
                  _locationFlag == 0) {
                _showSnakBarMsg(locationMissingMSG);
              } else if (_image == null) {
                _showSnakBarMsg(pictureMissingMSG);
              } else if (_currentCategory == null) {
                _showSnakBarMsg(categoryMissingMSG);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return LoadingDialog("Postavljanje objave je u toku.");
                  },
                  barrierDismissible: false,
                );
                category = _currentCategory.id;

                //upload image on server
                DateTime now = DateTime.now();
                String convertedDateTime =
                    "${now.year.toString()}${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}";

                String fileName = LoggedUser.id.toString() +
                    "_" +
                    convertedDateTime +
                    "_" +
                    basename(_image.path);
                await uploadImageNew(_image, postImageUploadURL, fileName);
                Post newPost = Post(
                    userID,
                    postTitle,
                    postDesctiption,
                    category,
                    DateTime.now(),
                    active,
                    postServerPathImage+ fileName,
                    address,
                    LoggedUser.data.cityID,
                    latitude,
                    longitude);

                var saveResponse =
                    await APIServicesPosts.addPost(globalJWT, newPost);
                await APIServicesUsers.fetchUserDataByID(
                        globalJWT, LoggedUser.id)
                    .then((value) {
                  LoggedUser.data = value;
                });

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage.city(cityID: LoggedUser.data.cityID),
                  ),
                );
              }
            }
          },
        )
      ],
    );
  }

  //new post body construction
  Widget buildBody(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //    verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Platform.isAndroid
                      ? FutureBuilder<void>(
                          future: retrieveLostData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const Text(
                                  'Fotografija nije postavljena.',
                                  textAlign: TextAlign.center,
                                );
                              case ConnectionState.done:
                                return _previewImage(context);
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Fotografija: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return const Text(
                                    'Fotografija nije postavljena.',
                                    textAlign: TextAlign.center,
                                  );
                                }
                            }
                          },
                        )
                      : _previewImage,
                ),

                SizedBox(height: 20.0),

                TextField(
                    autofocus: false,
                    onChanged: (val) {
                      postTitle = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Naslov",
                      border: OutlineInputBorder(),
                    )),
                //description section
                SizedBox(height: 20.0),
                TextField(
                    maxLines: null,
                    autofocus: false,
                    onChanged: (val) {
                      postDesctiption = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Opis",
                      border: OutlineInputBorder(),
                    )),

                SizedBox(height: 20.0),

                _currentAddress != null
                    ? textFunction(_currentAddress)
                    : Text(""),

                SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                onPressed: getImageGallery,
                                tooltip: 'Izaberite iz galerije',
                                icon: Icon(
                                  Icons.photo_library,
                                  size: 25,
                                ),
                                color: boja),
                            SizedBox(width: 5)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                onPressed: getImageCamera,
                                tooltip: 'Napravite novu fotografiju',
                                icon: Icon(Icons.photo_camera, size: 25.0),
                                color: boja),
                            SizedBox(width: 5)
                          ],
                        ),
                      ),
                    ),
                    //set marker on map
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.map,
                                color: Colors.teal,
                                size: 25.0,
                              ),
                              onPressed: () async {
                                var permission =
                                    await locationPermission.hasPermission();
                                var locationEnabled =
                                    await locationPermission.serviceEnabled();
                                if (permission == gps.PermissionStatus.denied) {
                                  _showSnakBar3sec(locationAllowMSG);
                                  await locationPermission.requestPermission();
                                } else if (locationEnabled == false) {
                                  _showSnakBar3sec(locationTurnOnMSG);
                                  await locationPermission.requestService();
                                } else {
                                  await geolocator
                                      .getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high)
                                      .then(
                                    (Position position) {
                                      double lat, long;
                                      print(latitude.toString() +
                                          " - " +
                                          longitude.toString());
                                      if (latitude != 0.0 && longitude != 0.0) {
                                        lat = latitude;
                                        long = longitude;
                                      } else {
                                        lat = position.latitude;
                                        long = position.longitude;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SetMarker(lat, long),
                                        ),
                                      ).then((value) async {
                                        setState(() {
                                          latitude = value['latitude'];
                                          longitude = value['longitude'];
                                        });
                                        List<Placemark> p = await geolocator
                                            .placemarkFromCoordinates(
                                                latitude, longitude);
                                        Placemark place = p[0];

                                        if (!mounted) return;
                                        setState(() {
                                          if (place.locality == '' &&
                                              place.thoroughfare != '' &&
                                              place.subThoroughfare != '')
                                            _currentAddress =
                                                "${place.thoroughfare} ${place.subThoroughfare}";
                                          else if ((place.thoroughfare == '' ||
                                                  place.subThoroughfare ==
                                                      '') &&
                                              place.locality != '')
                                            _currentAddress =
                                                "${place.locality}";
                                          else
                                            _currentAddress =
                                                "${place.thoroughfare} ${place.subThoroughfare}, ${place.locality}";
                                          location = _currentAddress;
                                          address =
                                              "${place.thoroughfare} ${place.subThoroughfare}";
                                          city = "${place.locality}";
                                          _locationFlag = 1;
                                        });
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 5)
                          ],
                        ),
                      ),
                    ),
                    //autolocation
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.red[900],
                                size: 25.0,
                              ),
                              onPressed: () async {
                                var permission =
                                    await locationPermission.hasPermission();
                                var locationEnabled =
                                    await locationPermission.serviceEnabled();
                                if (permission == gps.PermissionStatus.denied) {
                                  _showSnakBar3sec(locationAllowMSG);
                                  await locationPermission.requestPermission();
                                } else if (locationEnabled == false) {
                                  _showSnakBar3sec(locationTurnOnMSG);
                                  await locationPermission.requestService();
                                } else {
                                  await _getCurrentLocation();

                                  location = _currentAddress;
                                }
                              },
                            ),
                            SizedBox(width: 5)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.7,
                //   child: TextField(
                //     controller: _streetAddress,
                //     autofocus: false,
                //     decoration: InputDecoration(
                //       hintText: "Ulica i broj",
                //     ),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.5,
                //   child: TextField(
                //     controller: _townAddress,
                //     autofocus: false,
                //     decoration: InputDecoration(
                //       hintText: "Grad",
                //     ),
                //   ),
                // ),
                // FlatButton(
                //   child: Text("Pronadji adresu"),
                //   onPressed: () {
                //     print(_streetAddress.text + ", " + _townAddress.text);
                //     if (_streetAddress.text == "" || _townAddress.text == "") {
                //       _showSnakBarMsg("Adresa nije uneta.");
                //     } else {
                //       _getAddressFromString(
                //           _streetAddress.text + "," + _townAddress.text);
                //     }
                //   },
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildDropdownButton(),
                    //    buildPostButton(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildPostButton(context) {
  //   return FlatButton(
  //       child: Text("Objavite", style: TextStyle(color: Colors.white)),
  //       onPressed: () async {
  //         print(_locationFlag.toString() + "      location Flag");
  //         if (LoggedUser.data.isBlocked == false) {
  //           if (postTitle == null || postTitle == "") {
  //             _showSnakBarMsg(titleMissingMSG);
  //           } else if (_currentAddress == null || _currentAddress == "" || _locationFlag == 0) {
  //             _showSnakBarMsg(locationMissingMSG);
  //           } else if (_image == null) {
  //             _showSnakBarMsg(pictureMissingMSG);
  //           } else if (_currentCategory == null) {
  //             _showSnakBarMsg(categoryMissingMSG);
  //           } else {
  //             uploadImage(_image, postImageUploadURL);
  //             category = _currentCategory.id;

  //             Post newPost = Post(
  //               userID,
  //               postTitle,
  //               postDesctiption,
  //               category,
  //               DateTime.now(),
  //               active,
  //               postServerPathImage + basename(_image.path),
  //               address,
  //               LoggedUser.data.cityID,
  //               latitude,
  //               longitude,
  //             );
  //             APIServicesPosts.addPost(globalJWT, newPost).then(
  //               (value) {
  //                 if (value == true) {
  //                   APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
  //                       .then(
  //                     (value) {
  //                       LoggedUser.data = value;
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) =>
  //                               HomePage.fromBase64(globalJWT),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 }
  //               },
  //             );
  //           }
  //         } else {
  //           _showSnakBar3sec(blockedAccountMSG);
  //         }
  //       },
  //       shape: new RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(30.0),
  //       ),
  //       color: boja);
  // }

  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        elevation: 7.0,
      ),
    );
  }

  void _showSnakBar3sec(String msg) {
    _scaffoldstate.currentState.showSnackBar(
      new SnackBar(
        content: new Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        elevation: 7.0,
      ),
    );
  }

  //geolocaction from the device geolocator with high accuracy
  _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      latitude = _currentPosition.latitude;
      longitude = _currentPosition.longitude;
      print(latitude);
      print(longitude);
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  //making real address form latitude and longitute

  _getAddressFromString(String streetAddress) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromAddress(streetAddress);

      Placemark place = p[0];
      print(place.toJson().toString());
      if (!mounted) return null;
      setState(() {
        //shiw address
        if (place.thoroughfare == "") {
          _currentAddress = "Ulica nije pronađena.";
          _locationFlag = 0;
        } else {
          if (place.locality == '' &&
              place.thoroughfare != '' &&
              place.subThoroughfare != '')
            _currentAddress = "${place.thoroughfare} ${place.subThoroughfare}";
          else if ((place.thoroughfare == '' || place.subThoroughfare == '') &&
              place.locality != '')
            _currentAddress = "${place.locality}";
          else
            _currentAddress =
                "${place.thoroughfare} ${place.subThoroughfare}, ${place.locality}";
          location = _currentAddress;
          address = "${place.thoroughfare} ${place.subThoroughfare}";
          city = "${place.locality}";
          //new
          longitude = place.position.longitude;
          latitude = place.position.latitude;
          _locationFlag = 1;
        }
      });
    } catch (e) {
      setState(() {
        _locationFlag = 0;
        _currentAddress = "Lokacija nije pronađena.";
      });
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      if (!mounted) return;
      setState(() {
        if (place.locality == '' &&
            place.thoroughfare != '' &&
            place.subThoroughfare != '')
          _currentAddress = "${place.thoroughfare} ${place.subThoroughfare}";
        else if ((place.thoroughfare == '' || place.subThoroughfare == '') &&
            place.locality != '')
          _currentAddress = "${place.locality}";
        else
          _currentAddress =
              "${place.thoroughfare} ${place.subThoroughfare}, ${place.locality}";
        location = _currentAddress;
        address = "${place.thoroughfare} ${place.subThoroughfare}";
        city = "${place.locality}";
        _locationFlag = 1;
      });
    } catch (e) {
      print(e);
    }
  }

  //get image from the camera
  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  //get image from device gallery
  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  //retrieve the lost data
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

  //widget for image preview
  Widget _previewImage(context) {
    if (_image != null) {
      return Align(
          alignment: Alignment.center,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.file(_image)));
    } else {
      return Text("");
    }
  }

  //construction of text object
  Text textFunction(text) {
    return new Text(text,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17.0,
          //  fontWeight: FontWeight.bold,
        ));
  }

  showAlertDialog(BuildContext context) {
    Widget okay = FlatButton(
        child: Text("U redu."),
        onPressed: () async {
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage.fromBase64(globalJWT),
          );
        });

    AlertDialog alert = AlertDialog(
      title: Text("Obaveštenje."),
      content: Text(
          "Trenutno se nalazite na listi blokiranih korisnika.\nBlokirani korisnici ne mogu da pišu objave."),
      actions: <Widget>[
        okay,
      ],
    );

    showDialog(context: context, child: alert);
  }
}
