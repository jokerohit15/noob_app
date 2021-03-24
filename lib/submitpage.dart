import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:noob_app/imagedisplay.dart';
import 'package:permission_handler/permission_handler.dart';

class SubmitPage extends StatefulWidget {
  SubmitPage(this.image);
  final image;
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  String imageUrl, caption, date;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Image')),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              (widget.image != null)
                  ? Image.file(
                      File(widget.image.path),
                    )
                  : Placeholder(
                      fallbackHeight: 200.0, fallbackWidth: double.infinity),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Caption cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => caption = value),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Write a caption',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Date cannot be empty';
                    }
                    print(date);
                    return null;
                  },
                  onSaved: (value) => setState(() => date = value),
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'When was this photo taken?',
                  ),
                ),
              ),
              Container(
                  color: Colors.deepOrange,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        uploadImage();
                      }
                    },
                    child: Text('Submit'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      var file = File(widget.image.path);

      if (widget.image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('folderName/imageName')
            .putFile(file)
            .whenComplete(() => null);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        CollectionReference imgData =
            FirebaseFirestore.instance.collection('ImgData');
        setState(() {
          imageUrl = downloadUrl;
          imgData.add({'caption': caption, 'date': date});
        });
        if (imageUrl != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDisplay(
                imageUrl: imageUrl,
              ),
            ),
          );
        }
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
