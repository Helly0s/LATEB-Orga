import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  Future<void> checkAuthentification() async
  {
    _auth.onAuthStateChanged.listen((FirebaseUser user) {
      if(user != null)
        {
          Navigator.of(context).pushNamed('/HomePage');
        }
    });
  }

  Future<void> login() async
  {
    if (_formKey.currentState.validate())
      {
        _formKey.currentState.save();

        try {
          final AuthResult res = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
          final FirebaseUser user = res.user;

          assert (user != null);
          assert (await user.getIdToken() != null);

          final FirebaseUser currentUser = await _auth.currentUser();
          assert(user.uid == currentUser.uid);
        }
        catch(e) {
          showError("Couldn't log in.");
        }
      }
  }

  void showError(String errormessage) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
        title: const Text('ERROR'),
        content: Text(errormessage),

        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('OK')
          )
        ],
      );
    }
    );
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
                        onPressed: login,
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

                      const SizedBox(height: 300,)
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