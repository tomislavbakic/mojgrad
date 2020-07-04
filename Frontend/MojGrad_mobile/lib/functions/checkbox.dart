import 'package:flutter/material.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/models/category.dart';
import 'package:fronend/models/view/city.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/services/api.services.dart';

import '../main.dart';

class MyCheckbox {
  // String title = "";
  Category category;
  bool value;
  MyCheckbox(Category category, bool value) {
    //this.title = title;
    this.value = value;
    this.category = category;
  }
}

class CheckBoxes extends StatefulWidget {
  @override
  _CheckBoxesState createState() => _CheckBoxesState();
}

class _CheckBoxesState extends State<CheckBoxes> {
  List<MyCheckbox> cbList = List<MyCheckbox>();

  City _currentCity;
  int cityID = LoggedUser.data.cityID;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
                child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
        
                    child: Stack(children: <Widget>[
                      Positioned(
                          bottom: 12.0,
                          left: 16.0,
                          child: Text("Šta želite da vidite?",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500))),
                    ])),
              ),
              SizedBox(
                height: 30,
              ),

              // [Moj grad lep grad] checkbox
              categories(),
              Padding(
                padding: const EdgeInsets.only(left: 50, bottom: 20),
                child: Row(children: <Widget>[
                  buildDropdownButton(),
                ]),
              ),

              buttonConfirm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonConfirm() {
    return FlatButton(
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      //   elevation: 5,
      onPressed: () {
        List<Category> categoryList = List<Category>();
        for (var item in cbList) {
          if (item.value == true) categoryList.add(item.category);
        }
       
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage.category(category: categoryList, cityID: cityID),
          ),
        );
      },
      child: Text(
        "Primenite filter",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget categories() {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: FutureBuilder<List<Category>>(
        future: APIServices.fetchAllCategories(globalJWT),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator(
              backgroundColor: Colors.green,
            );
          else {
            for (int i = 0; i < snapshot.data.length; i++) {
              cbList.add(MyCheckbox(snapshot.data[i], false));
            }
            return Column(
                children: List.generate(
                    snapshot.data.length, (index) => checkbox(index)));
          }
        },
      ),
    );
  }

  Widget checkbox(int index) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: cbList[index].value,
          onChanged: (bool value) {
            setState(() {
              cbList[index].value = value;
            });
          },
          activeColor: Colors.green,
        ),
        Text(cbList[index].category.name),
      ],
    );
  }

  //dropdown grad
  Widget buildDropdownButton() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<City>>(
              future: APIServices.getAllCities(globalJWT),
              builder:
                  (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<City>(
                  items: snapshot.data
                      .map((city) => DropdownMenuItem<City>(
                            child: Text(city.name),
                            value: city,
                          ))
                      .toList(),
                  onChanged: (City value) {
                    setState(() {
                      _currentCity = value;
                      cityID = _currentCity.id;
                    });
                  },
                  isExpanded: false,
                  value: _currentCity == null
                      ? _currentCity
                      : snapshot.data
                          .where((i) => i.name == _currentCity.name)
                          .first,
                  hint: Text('Grad'),
                );
              }),
        ],
      ),
    );
  }
}
