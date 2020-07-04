import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class ShowOnMap extends StatefulWidget {
  double lat, long;

  ShowOnMap(lat, long) {
    this.lat = lat;
    this.long = long;
  }

  @override
  _ShowOnMapState createState() => new _ShowOnMapState();
}

class _ShowOnMapState extends State<ShowOnMap> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Lokacija problema'),
      ),
      body: new FlutterMap(
        options: new MapOptions(
            center: new LatLng(widget.lat, widget.long),
            minZoom: 10.0,
            maxZoom: 18.0),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new LatLng(widget.lat, widget.long),
                builder: (context) => new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {},
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
