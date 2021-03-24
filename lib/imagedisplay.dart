import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatefulWidget {
  final String imageUrl;

  const ImageDisplay({this.imageUrl});
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  CollectionReference imgData =
      FirebaseFirestore.instance.collection('ImgData');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Container(
        child: ListView(
          children: [
            (widget.imageUrl != null)
                ? Image.network(widget.imageUrl)
                : Placeholder(
                    fallbackHeight: 200.0, fallbackWidth: double.infinity),
            Container(
              child: StreamBuilder(
                stream: imgData.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator();
                  else {
                    return Column(
                      children: snapshot.data.docs.map((document) {
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(document['caption']),
                        );
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(document['date']),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
