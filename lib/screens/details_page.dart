import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

class DetailsPage extends StatelessWidget {
  final String imageSrc;
  DetailsPage({this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ZoomableImage(
        new NetworkImage(imageSrc),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
