import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<String>> images = getData();

  // Future<List<String>> imaget = imageList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: null)
          ],
          title: const Text('Netflix'),
        ),
        body: Container(
            margin: EdgeInsets.all(12),
            child: FutureBuilder(
                future: images,
                builder: (context, snapshot) {
                  return new StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) {
                        return new StaggeredTile.count(
                            1, index.isEven ? 1.2 : 1.6);
                        // ignore: dead_code
                      });
                })));
  }
}

Future<List<String>> getData() async {
  var details = 'telegram_media/_search/template';
  var url =
      "https://paas:0820eaaa1b5d715aa1e8033a5f444046@gimli-eu-west-1.searchly.com/" +
          details;
  var response = await http.post(url,
      body: '{"id": "default_search", "params": {"search_term": "cars"}}');

  var data;
  List<String> images = [];
  //  json.decode(response.body)['hits']['hits'];
  data = json.decode(response.body)['hits']['hits'];

  for (var prop in data) {
    print('called!');
    images.add(prop['_source']['imageUrl']);
  }

  print('ended');
  print(images);
  return images;
}
