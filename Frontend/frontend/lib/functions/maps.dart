import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class SetMarker extends StatefulWidget {
  double lat, long;

  SetMarker(double lat, double long) {
    this.lat = lat;
    this.long = long;
  }

  @override
  _SetMarkerState createState() => new _SetMarkerState();
}

class _SetMarkerState extends State<SetMarker> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Lokacija problema'),
      ),
      body: WillPopScope(
        onWillPop: () {
          var data = new Map<String, dynamic>();
          data['latitude'] = widget.lat;
          data['longitude'] = widget.long;
          Navigator.pop(context, data);
          return new Future(() => false);
        },
        child: new FlutterMap(
          options: new MapOptions(
              center: new LatLng(widget.lat, widget.long),
              onTap: _changeMarkerPosition,
              minZoom: 10.0,
              maxZoom: 18.0),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
      ),
    );
  }

  void _changeMarkerPosition(LatLng pos) {
   if (!mounted) return;
    setState(() {
      widget.lat = pos.latitude;
      widget.long = pos.longitude;
    });
  }
}
