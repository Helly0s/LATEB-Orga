import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password, _name;

  Future<void> checkAuthentification() async {
    _auth.onAuthStateChanged.listen((FirebaseUser user) {
      if (user != null)
        {
          Navigator.of(context).pushNamed('/HomePage');
        }
    });
  }

  @override
  void initState(){
    super.initState();
    checkAuthentification();
  }

  Future<void> signUp() async {
    if (_formKey.currentState.validate())
      {
        _formKey.currentState.save();

        try {
          final AuthResult res = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
          if (res.user != null)
          {
            final UserUpdateInfo updateuser = UserUpdateInfo();
            updateuser.displayName = _name;
            res.user.updateProfile(updateuser);
          }
        }
        catch(e) {
          debugPrint('error');
        }
      }
    else {
      debugPrint('error2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                          validator: (String input){
                            if (input.isEmpty)
                              return 'Enter Username';
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person)
                          ),
                          onSaved: (String input) => _name = input,
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (String input){
                            if (input.isEmpty)
                              return 'Enter Email';
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email)
                          ),
                          onSaved: (String input) => _email = input,
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          validator: (String input){
                            if (input.length < 6)
                              return 'Provide minimum 6 characters';
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock)
                          ),
                          obscureText: true,
                          onSaved: (String input) => _password = input,
                        ),
                      ),

                      const SizedBox(height: 20,),

                      RaisedButton(
                        padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                        onPressed: signUp,
                        child: const Text('Sign Up', style: TextStyle(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
