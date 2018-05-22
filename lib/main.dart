import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'models/booru_image.dart';

const String BASE_URL = "https://gelbooru.com/index.php?page=dapi&s=post&q=index&json=1";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'Inko'),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  HomePage({this.title});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title)
      ),
      body: new Content(),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => new _ContentState();
}

class _ContentState extends State<Content> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FutureBuilder(
        future: _getBooruImages(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData) {
            return new Center(child: new CircularProgressIndicator(),);
          }
          List<BooruImage> images = snapshot.data;
          return new CustomScrollView(
            primary: false,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(10.0),
                sliver: new SliverStaggeredGrid.count(
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  crossAxisCount: 4,
                  children: _createImageCards(images),
                  staggeredTiles: _generateRandomTiles(images.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<List<BooruImage>> _getBooruImages() async {

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(BASE_URL));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonResponse = await response.transform(utf8.decoder).join();
      var data = jsonDecode(jsonResponse);
      List results = data;
      List<BooruImage> imageList = BooruImage.getImages(results);
      return imageList;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

List<Widget> _createImageTiles(List<BooruImage> images) {
  List<Widget> imageTiles = new List();
  images.forEach((image){
    Widget tile = new GridTile(
      footer: new GridTileBar(
        backgroundColor: Colors.black54,
        title: new Text(image.image),
      ),
      child: new GestureDetector(
        child: new FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: image.fileUrl,
        ),
        onTap: (){},
      ),
    );
    imageTiles.add(tile);
  });
  return imageTiles;
}

List<Widget> _createImageCards(List<BooruImage> images){
  List<Widget> imageCards = new List();
  images.forEach((image){
    Widget card = new Card(
      child: new GestureDetector(
        child: new FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: image.fileUrl,
        ),
        onTap: (){},
      ),
    );
    imageCards.add(card);
  });
  return imageCards;
}

List<StaggeredTile> _generateRandomTiles(int count) {
  Random rnd = new Random();
  return new List.generate(count,
      (i) => new StaggeredTile.count(rnd.nextInt(4) + 1, rnd.nextInt(6) + 1));
}