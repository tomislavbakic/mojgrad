import 'package:flutter/material.dart';
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/view/feedback.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/token.session.dart';

class FeedbackView extends StatefulWidget {
  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: 500,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(controller: ScrollController(), children: <Widget>[
          FutureBuilder(
              future: APIServices.fetchAllFeedbacks(Token.getToken),
              builder: (BuildContext context,
                  AsyncSnapshot<List<FeedbackInfo>> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                      width: 100,
                      height: 100);
                if (snapshot.data.length == 0) {
                  return Container(
                    padding: EdgeInsets.all(30.0),
                    child: Text("Trenutno nema utisaka korisnika."),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      FeedbackInfo feedback = snapshot.data[index];

                      return buildFeedBackTile(feedback, context);
                    });
              }),
        ]),
      ),
    );
  }

/*
  Widget feedbackListView(FeedbackInfo feedback) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(feedback.fullName),
          Text(feedback.text),
        ],
      ),
    );
  }*/

  Widget buildFeedBackTile(FeedbackInfo feedback, BuildContext context) {
    return Card(
      elevation: 1,
      // width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(wwwrootURL + feedback.userPhoto),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 0),
                margin: EdgeInsets.only(bottom: 0),
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  feedback.fullName,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            margin: EdgeInsets.only(top: 0),
            padding: EdgeInsets.only(top: 0, left: 50, right: 20, bottom: 5),
            child: Text("${feedback.text}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15, letterSpacing: 1)),
          ),
          //SizedBox(height: 3),
        ],
      ),
    );
  }
}
