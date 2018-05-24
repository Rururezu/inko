import 'package:flutter/material.dart';

import 'screens/home_page.dart';

const String BASE_URL = "https://gelbooru.com/index.php?page=dapi&s=post&q=index&json=1";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'Inko'),
    );
  }
}

