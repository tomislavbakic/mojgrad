import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../config/configuration.dart';

class WebImageUpload extends StatefulWidget {
  @override
  _WebImageUploadState createState() => _WebImageUploadState();
}

class _WebImageUploadState extends State<WebImageUpload> {
  Image pickedImage;
  String videoSRC;

  @override
  void initState() {
    super.initState();
  }

  pickImage() async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    Image fromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    String base64Image = base64Encode(bytesFromPicker);

    await addImageWeb(base64Image);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
  }

  static Future<void> addImageWeb(String img) async {
    var url = imageUploadWebURL;
    var map = Map();
    map['img'] = img;
    var putBody = json.encode(map);
    var res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: putBody);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Web Example'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: SizedBox(
                          width: 200,
                          child: pickedImage,
                        ) ??
                        Container(),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                RaisedButton(
                  onPressed: () => pickImage(),
                  child: Text('Select Image'),
                ),
              ]),
            ])),
      ),
    );
  }
}
