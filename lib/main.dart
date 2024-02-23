import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'CaptureImagePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        camera: camera,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.camera});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final CameraDescription camera;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data = """
             <!DOCTYPE html><html>
              <head>
                  <p style = "padding : 280px 300px 0px 320px>
                  <option> appearance: none </option>
                  Sometimes we need to visualize 
                  the texture of the food or a
                  commodity for its QUALITY</p> 
                  <p padding : 1 px 300px 0px 310px>
       
                  So here is an app to find out.. </p>
                 
              </head>
              </head>
              </html>""";

  //<h1>
  //" Food Critic....."
  //</h1>
  //<p style = "padding : 280px 300px 0px 320px">
  //<p style = "padding : 1 px 300px 0px 310px" >
  //<option> appearance: none </option>
  int _counter = 0;

  late CameraDescription cCamera;

  /*
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  */

  void initState() {
    super.initState();
    cCamera = widget.camera;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: 2000,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image:
              const AssetImage("assets/images/foodcritic_background.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(1.0), BlendMode.dstATop),
            )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Html(
                  data: data,
                  //shrinkWrap: true,
                  //onlyRenderTheseTags: const { 'head','h1'},
                  style: {
                    "h1": Style(
                      //backgroundColor:
                      //const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      color: Colors.black87,
                      fontSize: FontSize(40.0),
                      fontStyle: FontStyle.italic,
                      //alignment: Alignment.,
                      //textAlign: TextAlign.center,
                      //fontWeight: FontWeight.w700,
                    ),
                    "p": Style(
                      //backgroundColor:
                      //const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      height:,
                      color: Colors.red[50],
                      fontSize: FontSize(20.0),

                      fontStyle: FontStyle.italic,
                      alignment: Alignment.center,
                    ),
                    "t": Style(
                      color: Colors.black,
                    ),
                  }),
              ElevatedButton(
                //style:Style.
                //focusNode: ,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CaptureImagePage(firstCamera: cCamera)));
                },
                child: const Text('Take a Picture',
                    selectionColor: Colors.green,
                    style: TextStyle(
                        height: 3,
                        fontSize: 10.0,
                        fontStyle: FontStyle.normal,
                        color: Colors.indigo)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
