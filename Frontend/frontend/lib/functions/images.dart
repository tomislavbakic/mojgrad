//dodavanje slika na server
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

// Future<String> uploadImage(File imageFile, String url) async {
//   var stream =
//       new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   var length = await imageFile.length();

//   var uri = Uri.parse(url);
//   var request = new http.MultipartRequest("POST", uri);
//   var multipartFile = new http.MultipartFile('files', stream, length,
//       filename: basename(imageFile.path));

//   request.files.add(multipartFile);
//   var response = await request.send();
//   print(response.statusCode);
//   response.stream.transform(utf8.decoder).listen((value) {
//     print(value);
//     return value;
//   });
//   return null;
// }


Future<String> uploadImageNew(File imageFile, String url, String fileName) async {
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(url);
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('files', stream, length,
      filename: fileName);

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
    return value;
  });
  return null;
}
