import 'package:flutter/material.dart';
import 'package:webproject/models/view/metric.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/token.session.dart';
import 'package:webproject/functions/graphs.dart';
import 'package:webproject/users/mobile/topUsers.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final ScrollController controller = ScrollController();

  Widget stats;
  Metric metric;
  @override
  void initState() {
    super.initState();
    APIServices.getMetricInfo(Token.getToken).then((value) {
      if (!mounted) return;
      setState(() {
        metric = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          metric != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Broj korisnika: ${metric.numberOfUsers}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Broj institucija: ${metric.numberOfOrganisations}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Broj objava: ${metric.numberOfPosts}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Prosečna ocena: ${metric.averageGrade}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Container(),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width /
                    4.5, // OVDE MENJAŠ VELIČINU GRAFIKONA, AKO DELIŠ VEĆIM BROJEM BIĆE MANJI
                child: ShowChartPie(),
              ),
              SizedBox(width: 5),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width /
                    5.0, // OVDE MENJAŠ VELIČINU GRAFIKONA
                child: ChartBar(),
              ),
            ],
          ),
          
          SizedBox(height: 20,),
          Text("Top 10 korisnika", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold) ,),
          ShowBestUsers(),
        ],
      ),
    );
  }
}
