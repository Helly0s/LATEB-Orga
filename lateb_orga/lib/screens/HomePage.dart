import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  bool isloggedin = false;
  
  Future<void> checkAuthentification() async {
    _auth.onAuthStateChanged.listen((FirebaseUser user) {
      if (user == null)
        {
          Navigator.of(context).pushNamed('/Start');
        }
    });
  }

  Future<void> getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser;
        isloggedin = true;
      });
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  @override
  void initState(){
    super.initState();
    checkAuthentification();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: !isloggedin? const CircularProgressIndicator():

        Column(
          children: <Widget>[
            Container(
              child: Text(
                'Hello ${user.displayName}, you are logging in as ${user.email}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            RaisedButton(
              padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
              onPressed: signOut,
              child: const Text('Sign out', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown
              )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
