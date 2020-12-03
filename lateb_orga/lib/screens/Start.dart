import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> checkAuthentification() async
  {
    _auth.onAuthStateChanged.listen((FirebaseUser user) {
      if(user != null)
      {
        Navigator.of(context).pushNamed('/HomePage');
      }
    });
  }

  Future<void> signInWithGoogle() async {
    FirebaseUser user;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    user = (await _auth.signInWithCredential(credential)).user;
    assert(user != null);
    assert (await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    Navigator.of(context).pushNamed('/HomePage');
  }

  @override
  void initState(){
    super.initState();
    checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xffde7b2d),
                Color(0xffF5A810)
              ],
            )
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0,),
            Container(
              height: 250,
              child: const Image(
                image: AssetImage('images/teubi.png'),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0,),
            const Text(
              'LATEB-Orga',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                  fontFamily: 'MoonFlower',
                  color: Colors.black),
            ),
            const SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/Login');
                  },
                  child: const Text('LOGIN', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown
                  )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                ),
                const SizedBox(width: 20.0),
                RaisedButton(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/SignUp');
                  },
                  child: const Text('REGISTER', style: TextStyle(
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
            const SizedBox(height: 20.0,),
            SignInButton(
              Buttons.Google,
              text: 'Sign up with Google',
              onPressed: signInWithGoogle,
            ),
            SignInButton(
              Buttons.Microsoft,
              text: 'Sign up with Outlook',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}