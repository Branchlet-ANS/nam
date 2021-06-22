import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
import '../data/user.dart';

//Source: https://firebase.flutter.dev/docs/auth/social/
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Center(child: Text("Error!"));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(child: Text("Loading!"));
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    return Center(child: Consumer<NamUser>(builder: (context, user, child) {
      return Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: ListView(
            children: [
              TextButton(
                  onPressed: signInWithGoogle,
                  child: Text("Sign in with Google")),
              SizedBox(height: 100),
              Text("Name"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                      initialValue: user.getName(),
                      onChanged: (value) {
                        user.setName(value);
                      })),
              Text("Sex"),
              Container(
                  width: 100,
                  height: 100,
                  child: DropdownButton<bool>(
                    value: user.getSex(),
                    onChanged: (bool? newValue) {
                      user.setSex(newValue);
                    },
                    items: <bool>[false, true]
                        .map<DropdownMenuItem<bool>>((bool value) {
                      return DropdownMenuItem<bool>(
                        value: value,
                        child: Text(value ? 'Male' : 'Female'),
                      );
                    }).toList(),
                  )),
              Text("Weight"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: user.getWeight().toString(),
                    onChanged: (value) => user.setWeight(double.parse(value)),
                  )),
              Text("Daily Kilocalories"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: user.getKilocalories().toString(),
                    onChanged: (value) {
                      user.setKilocalories(double.parse(value));
                    },
                  ))
            ],
          ));
    }));
  }
}
