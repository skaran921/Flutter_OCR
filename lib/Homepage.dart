import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "ML KIT",
          style: TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
      child: MyApp(),
      backgroundColor: CupertinoColors.white,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  List texts = [];
  bool isLoading = false;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    texts.clear();
  }

  Future readText() async {
    FirebaseVisionImage mySelectedImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(mySelectedImage);

    for (TextBlock b in readText.blocks) {
      for (TextLine l in b.lines) {
        for (TextElement word in l.elements) {
          print(word.text);
          texts.add(word.text);
        }
      }
    }

    setState(() {
      this.texts = this.texts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _image != null
            ? Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(_image), fit: BoxFit.fill)),
              )
            : Text("Image Not Selected!!!"),
        CupertinoButton(
          child: Text("Select Image"),
          color: CupertinoColors.black,
          onPressed: () {
            this.getImage();
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        CupertinoButton(
          child: Text("OCR"),
          color: CupertinoColors.black,
          onPressed: () {
            this.readText();
          },
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: texts.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Text(texts[index]);
            })
      ],
    );
  }
}
