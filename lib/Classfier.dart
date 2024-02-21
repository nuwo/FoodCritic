import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:foodcritic/ClassifierCategory.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'ClassifierLabels.dart';
import 'ClassifierModel.dart';
import 'jsonapi.dart';

String identifiedTexture = "identified-texture";

class Classifier {
  late ClassifierLabels label;

  late ClassifierModel model;

  Classifier();

  Classifier._({required this.label, required this.model});

  static Future<ClassifierLabels> _loadLabels(String labelFileName) async {
    final rawLabels = await FileUtil.loadLabels(labelFileName);
    final labels = rawLabels
        .map((label) => label.substring(label.indexOf(' ')).trim())
        .toList();

    return ClassifierLabels(labels: labels);
  }

  static Future<ClassifierModel> _loadModel(String modelFileName) async {
    print('in function _loadModel');
    final interpreter = await Interpreter.fromAsset(modelFileName);

    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;

    final inputType = interpreter.getInputTensor(0).type;
    final outputType = interpreter.getOutputTensor(0).type;

    print(inputType);
    print(outputType);

    return ClassifierModel(
        interpreter: interpreter,
        inputShape: inputShape,
        outputShape: outputShape,
        inputType: inputType,
        outputType: outputType);
  }

  Future<Classifier> method() async {
    print('In classifier : method');
    final labels = await _loadLabels("assets/labels/Labels.csv");
    final models = await _loadModel("tfliteModel/LinearRegressionModel.tflite");
    return Classifier._(label: labels, model: models);
  }
}
