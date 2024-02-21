import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierModel {
  late Interpreter interpreter;

  late List<int> inputShape;
  late List<int> outputShape;

  late var inputType;
  late var outputType;

  ClassifierModel(
      {required this.interpreter,
      required this.inputShape,
      required this.outputShape,
      required this.inputType,
      required this.outputType});
}
