import 'package:flutter/material.dart';
import '../models/booru_image.dart';
import 'package:zoomable_image/zoomable_image.dart';

class DetailsPage extends StatelessWidget {
  final BooruImage image;
  DetailsPage({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(image.tags),
      ),
      body: new Container(
          child: new ZoomableImage(
            new NetworkImage(image.fileUrl),
            placeholder: new Center(child: CircularProgressIndicator()),
            backgroundColor: Colors.blue,
          ),
      ),
    );
  }
}
