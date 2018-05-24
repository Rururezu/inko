import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../main.dart';
import '../screens/details_page.dart';
import '../models/booru_image.dart';

List<BooruImage> images;

class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title});

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  SearchBar searchBar;
  String tags="";

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(widget.title),
      actions: <Widget>[searchBar.getSearchAction(context)],
    );
  }

  HomePageState() {
    searchBar = new SearchBar(
      inBar: true,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: (String value) {
        setState(() {
          tags = value;
          images = [];
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      body: new Content(tags: tags),
    );
  }
}

class Content extends StatefulWidget {
  final String tags;
  Content({this.tags});

  @override
  _ContentState createState() => new _ContentState();
}

class _ContentState extends State<Content> {

  List<Widget> _createTagsChip(String query) {
    List<Widget> tagChips = new List();
    List<String> tags = query.split(" ").toList();
    List<ColorSwatch> colors = [Colors.red, Colors.green, Colors.blue, Colors.amber];
    
    if(query == "") {
      tagChips.add(new Container());
      return tagChips;
    }

    tagChips.add(new Text("Query tags:  "));
    tags.forEach((tag){
      Widget chip = new Chip(
        backgroundColor: colors[new Random().nextInt(colors.length)],
        label: new Text(tag, style: new TextStyle(color: Colors.white),),
      );
      tagChips.add(chip);
      tagChips.add(new Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),));
    });
    return tagChips;
  }

  FutureBuilder<List<BooruImage>> _booruFutureBuilder(){
    return new FutureBuilder(
      future: _getBooruImages(widget.tags),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState != ConnectionState.done && !snapshot.hasData)
          return new Center(child: new CircularProgressIndicator(),);
        if(snapshot.connectionState == ConnectionState.done && !snapshot.hasData)
            return new Center(child: new Text("No images found"),);
        else {
          images = snapshot.data;
          return new CustomScrollView(
            primary: false,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(10.0),
                sliver: new SliverStaggeredGrid.count(
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  crossAxisCount: 2,
                  children: _createImageCards(images, context),
                  staggeredTiles: _generateRandomTiles(images.length),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 6.0, 4.0, 4.0), 
          child: new Row(
            children: _createTagsChip(widget.tags),
          ),
        ),
        new Flexible(
          child: _booruFutureBuilder(),
        ),
      ],
    );
  }
}

Future<List<BooruImage>> _getBooruImages(String tags) async {

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse("$BASE_URL&tags=$tags"));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonResponse = await response.transform(utf8.decoder).join();
      var data = jsonDecode(jsonResponse);
      List results = data;
      if(results != null) {
        List<BooruImage> imageList = BooruImage.getImages(results);
        return imageList;
      } else {
        return null;
      }
    } else {
      print("An error occured.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

List<Widget> _createImageCards(List<BooruImage> images, BuildContext context) {
  List<Widget> imageTiles = new List();
  images.forEach((BooruImage image){
    Widget tile = new Card(
      child: new GridTile(
        footer: new GridTileBar(
          backgroundColor: Colors.black54,
          title: new Text(image.id.toString(), textAlign: TextAlign.center,),
        ),
        child: new GestureDetector(
          child: new FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: image.fileUrl,
            fit: BoxFit.cover,
          ),
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(
              builder: (_) => new DetailsPage(image: image)
            ));
          },
        ),
      ),
    );
    imageTiles.add(tile);
  });
  return imageTiles;
}


List<StaggeredTile> _generateRandomTiles(int count) {
  Random rnd = new Random();
  return new List.generate(count, (i) => new StaggeredTile.count(1, i.isEven? 2:1));
  //return new List.generate(count,
  //    (i) => new StaggeredTile.count(rnd.nextInt(2) + 1, rnd.nextInt(4) + 1));
}