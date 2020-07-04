import 'dart:convert';
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/rank.dart';
import 'package:webproject/models/view/ranksInfo.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/config/config.error.dart';
import 'package:webproject/functions/loadingDialog.dart';

class Ranks extends StatefulWidget {
  @override
  _RanksState createState() => _RanksState();
}

class _RanksState extends State<Ranks> {
  String image = "";
  String rankName = "";
  int fromValue = 0;
  int toValue = 0;
  String errorMSG = "";
  bool isVisible = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30.0),
              ),
              // DA SE PRI DODAVANJU NOVOG NIVOA, OBRATI PAŽNJA DA BUDE VIŠI
              // BROJ POENA OD POSLEDNJEG UNETOG NIVOA
              buildExistingRanks(),
              SizedBox(height: 20.0),
              addNewRank(),
              SizedBox(height: 20.0),
              // KADA SE KLIKNE NA DUGME DODAJ NOVI NIVO
              Visibility(
                visible: isVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 90.0),
                      child: Row(
                        children: [
                          RaisedButton(
                            child: Text(
                              "Slika nivoa",
                              style: TextStyle(
                                  color: Colors.green, //green
                                  fontSize: 15.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              image = pickImage();
                            },
                          ),
                          SizedBox(height: 10.0),
                          error != null
                              ? Text(error)
                              : data != null
                                  ? Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      width: 50,
                                      height: 50,
                                      child: Image.memory(data))
                                  : Text(''), //Text('No data...'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 90.0),
                            child: Text(
                              "Naziv nivoa ",
                              style: TextStyle(
                                color: Colors.black, //green
                                fontSize: 15.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 100,
                            child: TextFormField(
                              onChanged: (value) {
                                rankName = value;
                              },
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 90.0),
                            child: Text(
                              "Opseg poena ",
                              style: TextStyle(
                                color: Colors.black, //green
                                fontSize: 15.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                //OBAVEZNO PROVERITI DA LI SU UNEE SAMO CIFRE
                                fromValue = int.parse(value);
                              },
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                //hintText: hintText,
                                //prefixIcon: Icon(icon, color: Colors.green)),
                              ),
                            ),
                          ),
                          Text("  -  "),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                toValue = int.parse(value);
                              },
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                //hintText: hintText,
                                //prefixIcon: Icon(icon, color: Colors.green)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    errorMSG != ""
                        ? Container(
                            padding:
                                EdgeInsets.only(left: 90, top: 10, bottom: 10),
                            child: Text(errorMSG,
                                style: TextStyle(color: Colors.red)))
                        : SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 75.0),
                      width: 150,
                      height: 35,
                      child: RaisedButton(
                        // KADA SE KLIKNE NA SAČUVAJ
                        onPressed: () {
                          if (image != "" &&
                              fromValue != 0 &&
                              toValue != 0 &&
                              rankName != "" &&
                              name != "") {
                            if (fromValue < toValue) {
                              Dialogs.showLoadingDialog(context, _keyLoader);
                              String base64Image = base64Encode(data);
                              APIServices.addImageWeb(
                                      base64Image, rankUploadServerRoute)
                                  .then(
                                (value) {
                                  String val = jsonDecode(value);
                                  Rank newRank = new Rank(
                                      rankName, val, fromValue, toValue);
                                  setState(
                                    () {
                                      APIServices.addNewRank(
                                              Token.getToken, newRank)
                                          .then(
                                        (value) {
                                          if (value == false) {
                                            setState(
                                              () {
                                                errorMSG = instructionRankgMSG;
                                              },
                                            );
                                          } else {
                                            errorMSG = "";
                                            _toggle();
                                          }
                                        },
                                      );
                                      Navigator.of(_keyLoader.currentContext)
                                          .pop();
                                    },
                                  );
                                },
                              );
                            } else {
                              setState(
                                () {
                                  errorMSG = instructionRankgMSG;
                                },
                              );
                            }
                          } else {
                            setState(
                              () {
                                errorMSG = instructionRankgMSG;
                              },
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                        ),
                        color: Colors.white,
                        child: Text(
                          "Sačuvaj",
                          style: TextStyle(
                              color: Colors.green, //green
                              fontSize: 15.0,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExistingRanks() {
    return Container(
      child: FutureBuilder(
        future: APIServices.getAllRanks(Token.getToken),
        builder:
            (BuildContext context, AsyncSnapshot<List<RanksInfo>> snapshot) {
          if (!snapshot.hasData)
            return Container(
                child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
                width: 100,
                height: 100);
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              RanksInfo rank = snapshot.data[index];
              bool last;

              if (index + 1 == snapshot.data.length)
                last = true;
              else
                last = false;
              return buildRank(rank, context, last);
            },
          );
        },
      ),
    );
  }

  //------------------- IMAGE PICKER ----------------------------------------------

  String name = '';
  String error = "";
  Uint8List data;

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  // ----------------------------------------------------------------------------------------

  void _toggle() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  // U SUSTINI DUGME DODAJ NOVI NIVO
  Widget addNewRank() {
    return Container(
      margin: EdgeInsets.only(left: 90.0),
      width: 150,
      height: 35,
      child: RaisedButton(
        // KADA SE KLIKNE NA DODAJ NOVI NIVO
        onPressed: () {
          _toggle();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)),
        ),
        color: Colors.grey[800],
        child: Text(
          "Dodaj novi nivo",
          style: TextStyle(
            color: Colors.white, //green
            fontSize: 15.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget buildRank(RanksInfo rank, BuildContext context, bool last) {
//hardcodovano da se nebrise nikad
    last = false;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(wwwrootURL + rank.urlPath),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Text(
                  rank.name,
                  style: TextStyle(fontSize: 20, letterSpacing: 1),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text(
                rank.minPoints.toString() +
                    " - " +
                    rank.maxPoints.toString() +
                    " EKO poena",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1)),
          ),
          last == true
              ? IconButton(
                  iconSize: 20.0,
                  // AKCIJA OBRISI NIVO IZ SISTEMA
                  onPressed: () async {
                    await APIServices.deleteLastRank(Token.getToken, rank.id);
                    setState(
                      () {
                        print("Obrisano");
                      },
                    );
                  },
                  icon: Icon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
