import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //save the result of gallery file
  File galleryFile;

  //save the result of camera file
  File cameraFile;
  List<Face> faces;
  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

  @override
  Widget build(BuildContext context) {
    imageSelectorGallery() async {
      File galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {
        this.galleryFile = galleryFile;
      });
    }

    //display image selected from camera
    imageSelectorCamera() async {
      File cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      print("You selected camera image : " + cameraFile.path);
      setState(() {
        this.cameraFile = cameraFile;
      });
    }
    clean() {
      cameraFile = null;
      galleryFile = null;
      setState(() {
        this.cameraFile = cameraFile;
        this.galleryFile = galleryFile;
      });
    }
    readFace() async {
      File imageFile = cameraFile != null ? cameraFile : galleryFile;
      FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      List<Face> faces = await faceDetector.processImage(visionImage);
      print(faces);
      setState(() {
        this.faces = faces;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: imageSelectorGallery,
                    child: Text("Galeria"), color: Colors.blueGrey,
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: imageSelectorCamera,
                    child: Text("Cámara"), color: Colors.black45,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: cameraFile != null || galleryFile != null,
                  child: Expanded(
                    child: FlatButton(
                      onPressed: readFace,
                      child: Text("Leer Rostros"), color: Colors.lightGreen,
                    ),
                  ),
                ),
                Visibility(
                  visible: cameraFile != null || galleryFile != null,
                  child: Expanded(
                    child: FlatButton(
                      onPressed: clean,
                      child: Text("Limpiar"), color: Colors.red,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
