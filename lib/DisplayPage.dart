import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'dart:io';

import 'Classfier.dart';
import 'ClassifierCategory.dart';
import 'jsonapi.dart';

class DisplayPage extends StatelessWidget {
  final image;
  const DisplayPage({super.key, required this.image});

  Widget build(BuildContext context) {
    return Inference(picture: image);
  }
}

class Inference extends StatefulWidget {
  late File picture;
  //late String prediction;
  Inference({super.key, required this.picture});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InferenceState(scannedImage: picture);
  }
}

class InferenceState extends State<Inference> {
  late final scannedImage;
  //late Uint8List? _byte;
  InferenceState({required this.scannedImage});

  Future<String> _preProcessInput(File image,
      String Function(Map<String, dynamic> data) onDecodeData) async {
    String result;
    Completer<String> c = Completer<String>();
    getData(image).asStream().forEach((data) {
      result = onDecodeData(jsonDecode(data));
      c.complete(result);
      print('result in preProcess input');
      print(c.future);
    });
    return c.future;

    /*
    String texture ="";
    String result;
    Completer<String> c = Completer<String>();
    texture = getData(image).asStream().listen((data) {
      result = onDecodeData(jsonDecode(data));
      print('On Decode Data');
      print(result);
      texture=result;
      onDone: {
        print("Done + $texture");
        print(result);
        c.complete(result);


      }
    }) as String;
    */
  }
/*
  Future<String> predict(File image) {
    var result;
    try {
      var result = _preProcessInput(image, onDecodeData);

    } catch (e) {
      print(e.toString());
    }
    return result;
  }
*/

  @override
  Scaffold build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inference'),
      ),
      body: Container(
          child: FutureBuilder(
              future: getData(scannedImage),
              builder: (context, snapshot) {
                String? displayLabel = "displaying texture.........";
                print("in future builder ");
                if (!snapshot.hasData) {
                  const CircularProgressIndicator(
                    semanticsLabel: "retreiving",
                  );
                }
                //print('snapshot of data');
                //print(snapshot.data);

                return FutureBuilder(
                    future: onDecodeData(snapshot.data),
                    builder: (context, snapshot1) {
                      //print('Second future builder');
                      //print(snapshot1.data);
                      if (!snapshot1.hasData) {
                        const CircularProgressIndicator(
                          semanticsLabel: "retreiving",
                        );
                      }
                      if (snapshot1.hasData) {
                        displayLabel = snapshot1.data;
                      }

                      return Container(
                          child: Column(children: [
                        Image.file(
                          widget.picture,
                          height: 400.0,
                          width: 500.0,
                          fit: BoxFit.fill,
                        ),
                        Text(displayLabel!,
                            style: const TextStyle(
                                height: 5,
                                fontSize: 40.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.indigo))
                      ]));
                    });
              })),
    );
  }

  Future<String> onDecodeData(var inputTensor) async {
    Classifier classifier = Classifier();
    Classifier c = await classifier.method();

    //print("response from server");
    //print(inputTensor);
    var decodedData = jsonDecode(inputTensor);
    final inputBuffer = decodedData['probability'];

    //print('creating output buffer');
    final outputBuffer =
        TensorBuffer.createFixedSize(c.model.outputShape, c.model.outputType);

    c.model.interpreter.run(inputBuffer, outputBuffer.buffer);

    //print(outputBuffer.getDoubleList());

    final probabilityProcessor = TensorProcessorBuilder().build();

    probabilityProcessor.process(outputBuffer);

    final labelledResult = TensorLabel.fromList(c.label.labels, outputBuffer);

    final categoryList = [];
    labelledResult.getMapWithFloatValue().forEach((key, value) {
      categoryList.add(ClassifierCategory(label: key, score: value));
    });

    categoryList.sort((a, b) => (b.score > a.score ? 1 : -1));

    final interpreterResult = categoryList.first;

    var identifiedTexture = interpreterResult.getLabel();
    return identifiedTexture;
  }
}
