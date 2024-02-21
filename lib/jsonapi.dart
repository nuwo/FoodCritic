import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

Future getData(File image) async {
  var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
  var length = await image.length();
  print(stream);
  print(length);
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  print(basename(image.path));
  var request = http.MultipartRequest(
    'POST',
    Uri.parse("http://192.168.0.119:5000/api?file="),
  );

  var multipartFileSign = new http.MultipartFile('image', stream, length,
      filename: basename(image.path));

  //request.files.add(await http.MultipartFile('image',
  // image.readAsBytes().asStream(),
  //image.lengthSync(),
  //filename: image.path.split('/').last
  //));

  request.files.add(multipartFileSign);
  // request.headers["Content-type"]= 'image/jpg';
  request.headers.addAll(headers);

  var res = await request.send();

  http.Response response = await http.Response.fromStream(res);

  return response.body;
}
