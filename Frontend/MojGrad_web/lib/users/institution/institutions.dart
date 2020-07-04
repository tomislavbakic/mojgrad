import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/functions/loadingDialog.dart';
import 'package:webproject/models/view/organisationView.dart';
import 'package:webproject/services/api.services.org.dart';
import 'package:webproject/services/token.session.dart';

class Institutions extends StatefulWidget {
  @override
  _InstitutionsState createState() => _InstitutionsState();
}

class _InstitutionsState extends State<Institutions> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    {
      return Expanded(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          debugShowCheckedModeBanner: false,
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  backgroundColor: Colors.green,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Odobravanje institucija",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sve institucije",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(child: buildUnverifiedOrg()),
                  SingleChildScrollView(child: buildVerifiedOrg()),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget horizontalLine() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }

  Widget buildUnverifiedOrg() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: FutureBuilder<List<OrganisationView>>(
        future: APIServicesOrg.fetchUnverifiedOrganisation(Token.getToken),
        builder: (BuildContext context,
            AsyncSnapshot<List<OrganisationView>> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()));
          if (snapshot.data.length == 0) {
            return Container(
              padding: EdgeInsets.all(30.0),
              child: Text("Nema institucija koje čekaju potvrdu."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              OrganisationView org = snapshot.data[index];
              return _buildOrganisations(context, org);
            },
          );
        },
      ),
    );
  }

  Widget buildVerifiedOrg() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: FutureBuilder<List<OrganisationView>>(
        future: APIServicesOrg.fetchAllOrganisation(Token
            .getToken), //OVDE TRENUTNO PRIKAZUJE SVE ORGANIZACIJE, A TREBA SAMO ONE KOJE SU VERIFIKOVANE
        builder: (BuildContext context,
            AsyncSnapshot<List<OrganisationView>> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Container(
                    width: 50, height: 50, child: CircularProgressIndicator()));
          if (snapshot.data.length == 0) {
            return Container(
              padding: EdgeInsets.all(30.0),
              child: Text("Nema institucija u sistemu."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              OrganisationView org = snapshot.data[index];
              return _buildOrganisationsVerified(context, org);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrganisations(BuildContext context, OrganisationView org) {
    return Container(
      child: approveInstitution(
        organisationID: org.id,
        name: "${org.name}",
        organisationImage: org.photo != null
            ? wwwrootURL + org.photo
            : wwwrootURL + "Upload//Organisations//default.png",
        city: "${org.location}",
        activity: "${org.activity}",
        phone: "${org.phone}",
        email: "${org.email}",
      ),
    );
  }

  Widget _buildOrganisationsVerified(
      BuildContext context, OrganisationView org) {
    return Container(
      child: existingInstitution(
        organisationID: org.id,
        name: "${org.name}",
        organisationImage: org.photo != null
            ? wwwrootURL + org.photo
            : wwwrootURL + "Upload//Organisations//default.png",
        city: "${org.location}",
        activity: "${org.activity}",
        phone: "${org.phone}",
        email: "${org.email}",
        verified: org.isVerificated,
      ),
    );
  }

  Widget approveInstitution({
    int organisationID,
    String organisationImage,
    String name,
    String city,
    String activity,
    String phone,
    String email,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(organisationImage),
                      fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ]),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    activity,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    phone,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    email,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 20.0,
                    onPressed: () {
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      APIServicesOrg.verificateOrganisationByID(
                              Token.getToken, organisationID)
                          .then(
                        (value) {
                          setState(() {
                            print(value);
                            Navigator.of(_keyLoader.currentContext).pop();
                          });
                        },
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.check,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    iconSize: 20.0,
                    onPressed: () {
                      APIServicesOrg.deleteOrganisationAdminByID(
                              Token.getToken, organisationID)
                          .then(
                        (value) {
                          setState(() {
                            print(value);
                          });
                        },
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.times,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// ZA DRUGI TAB
// MADA U DRUGOM TABU SAMO TREBA ISPIS SVIH

  Widget existingInstitution({
    int organisationID,
    String organisationImage,
    String name,
    String city,
    String activity,
    String phone,
    String email,
    bool verified,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        color: verified == false ? Colors.grey[300] : Colors.white,
        elevation: 3,
        child: ListTile(
          leading: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(organisationImage),
                        fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(
                activity,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(
                phone,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Text(
                email,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          trailing: IconButton(
            iconSize: 20.0,
            onPressed: () {
              APIServicesOrg.deleteOrganisationAdminByID(
                      Token.getToken, organisationID)
                  .then(
                (value) {
                  setState(() {
                    print(value);
                  });
                },
              );
            },
            icon: Icon(
              FontAwesomeIcons.times,
              color: Colors.red,
              //size: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
