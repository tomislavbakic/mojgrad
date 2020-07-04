import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:webproject/models/view/genderInfo.dart';
import 'package:webproject/models/view/statisticInfo.dart';
import 'package:webproject/services/api.services.dart';
import 'package:webproject/services/token.session.dart';

class User {
  String users;
  double userValue;
  Color color;

  User(this.users, this.userValue, this.color);
}

class ShowChartPie extends StatefulWidget {
  @override
  _ChartPieState createState() => _ChartPieState();
}

class _ChartPieState extends State<ShowChartPie> {
  List<charts.Series<User, String>> _pieData;
  @override
  void initState() {
    super.initState();
    _pieData = List<charts.Series<User, String>>();
    APIServices.getAllStatisticInfo(Token.getToken).then((value) {
      print(value.length);
      _generateDataPie(value);
    });
  }

  _generateDataPie(List<StatisticInfo> s) {
    print(s.length);
    List<User> pieData = [
      new User(s[0].categoryName, double.parse(s[0].percentageOfAllPosts),
          Colors.red),
      new User(s[1].categoryName, double.parse(s[1].percentageOfAllPosts),
          Colors.blueAccent),
      new User(s[2].categoryName, double.parse(s[2].percentageOfAllPosts),
          Colors.deepOrange),
      new User(s[3].categoryName, double.parse(s[3].percentageOfAllPosts),
          Colors.green),
      new User(s[4].categoryName, double.parse(s[4].percentageOfAllPosts),
          Colors.grey),
    ];

    _pieData.add(
      charts.Series(
        data: pieData,
        domainFn: (User info, _) => info.users,
        measureFn: (User info, _) => info.userValue,
        colorFn: (User info, _) => charts.ColorUtil.fromDartColor(info.color),
        id: 'Pie',
        labelAccessorFn: (User row, _) => '${row.userValue}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_pieData.length == 0) return Container();
    return DefaultTabController(
      length: 1,
      child: TabBarView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: charts.PieChart(
                        _pieData,
                        animate: true,
                        animationDuration: Duration(seconds: 1),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.middleDrawArea,
                            position: charts.BehaviorPosition.end,
                            horizontalFirst: false,
                            desiredMaxRows: 6,
                            cellPadding: new EdgeInsets.only(
                                right: 4.0, bottom: 4.0, top: 4.0),
                            entryTextStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette.black,
                                fontSize: 12),
                          )
                        ],
                        layoutConfig: charts.LayoutConfig(
                            topMarginSpec: charts.MarginSpec.defaultSpec,
                            bottomMarginSpec: charts.MarginSpec.defaultSpec,
                            leftMarginSpec: charts.MarginSpec.defaultSpec,
                            rightMarginSpec: charts.MarginSpec.defaultSpec),
                        defaultRenderer: charts.ArcRendererConfig(
                            arcRendererDecorators: [
                              charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChartBar extends StatefulWidget {
  @override
  _ChartBarState createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
  List<charts.Series<User, String>> _seriesData;

  _generateData(GenderInfo value) {
    var barData = [
      new User('Muški pol %', double.parse(value.percentOfMale), Colors.blueAccent),
      new User(
          'Ženski pol %', double.parse(value.percentOfFemale), Colors.redAccent),
    ];

    _seriesData.add(
      charts.Series(
        data: barData,
        domainFn: (User user, _) => user.users,
        measureFn: (User user, _) => user.userValue,
        id: 'Bar',
        fillPatternFn: (_, __) => charts.FillPatternType.forwardHatch,
        fillColorFn: (User user, _) =>
            charts.ColorUtil.fromDartColor(user.color),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<User, String>>();
    APIServices.getGenderInfo(Token.getToken).then((value) {
      _generateData(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_seriesData.length == 0) return Container();
    return DefaultTabController(
      length: 1,
      child: TabBarView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: charts.BarChart(
                        _seriesData,
                        animate: true,
                        animationDuration: Duration(seconds: 2),
                        barGroupingType: charts.BarGroupingType.grouped,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
