import 'package:flutter/cupertino.dart';
import './Homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: "ML kit",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
