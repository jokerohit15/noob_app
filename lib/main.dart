import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noob_app/signupbutton.dart';
import 'package:noob_app/submitpage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image'), actions: [
        SignupButton(user),
      ]),
      body: Center(
        child: Container(
          color: Colors.deepOrange,
          child: ElevatedButton(
            child: Text('Upload Image'),
            onPressed: () => CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              text: "Choose",
              confirmBtnText: 'Camera',
              cancelBtnText: 'Gallery',
              onConfirmBtnTap: () => sendImageCamera(),
              onCancelBtnTap: () => sendImageGallery(),
            ),
          ),
        ),
      ),
    );
  }

  sendImageCamera() async {
    final _picker = ImagePicker();
    var image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.camera);

      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitPage(image),
          ),
        );
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  sendImageGallery() async {
    final _picker = ImagePicker();
    var image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);

      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitPage(image),
          ),
        );
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
