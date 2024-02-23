//import 'dart:js_interop';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'Classfier.dart';
import 'DisplayPage.dart';

class CaptureImagePage extends StatelessWidget {
  final CameraDescription firstCamera;

  const CaptureImagePage({
    required this.firstCamera,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TakePicture(
      camera: firstCamera,
    );
  }
}

class TakePicture extends StatefulWidget {
  const TakePicture({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureState createState() {
    // TODO: implement createState
    return TakePictureState();
  }
}

class TakePictureState extends State<TakePicture> {
  @override
  late CameraController _controller;
  late Future<void> _intializeCameraControllerFuture;
  late File image;

  //Future<Directory?>? _downloadsDirectory;
  //late String _identifiedTexture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _intializeCameraControllerFuture = _controller.initialize();

    //final Directory? result = await getDownloadsDirectory();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      print('comes here');
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      print('image');
      print(image);

      if (image == null) return;

      print(image.path);
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image:$e');
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Picture'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<void>(
            future: _intializeCameraControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Wrap(
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (image == null) return;
                    final imageTemp = File(image.path);

                    setState(() => this.image = imageTemp);

                    print(this.image);

                    //get image from library
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPage(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          //label:_identifiedTexture,
                          image: this.image?.absolute,
                        ),
                      ),
                    );
                  } on PlatformException catch (e) {
                    print('Failed to pick image:$e');
                  }
                },
                child: const Text(
                  'Choose from Library',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  try {
                    await _intializeCameraControllerFuture;
                    final image = await _controller.takePicture();
                  } catch (e) {
                    print(e);
                  }

                  if (!mounted) return;
                  final imageTemp = File(image.path);
                  setState(() => this.image = imageTemp);
                  //take image from image path
                  //Pass it to inference display page
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPage(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          //label:_identifiedTexture,
                          image: this.image?.absolute,
                        ),
                      ),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Press to take picture",
                    style: TextStyle(
                      fontSize: 10.0,
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
