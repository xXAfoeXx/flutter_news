import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            minVerticalPadding: 30,
            title: Text('Titre'),
            subtitle: Text('Source'),
            trailing: IconButton(
                onPressed: () {
                  Share.share("url");
                },
                icon: Icon(Icons.share)),
            leading: Container(
              height: 300,
              width: 200,
              color: Colors.amber,
              child: Text("Image"),
            ),
          );
        },
      )),
    );
  }
}
