import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../pages/configur.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );
// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final Map<String, dynamic> _formdata = {'email': '', 'password': ''};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Widget _emailTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'EMAIL',
        hintText: 'SONIK@gmail.com',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        icon: Icon(
          Icons.email,
          color: Colors.black,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'please Enter a valid Email';
        }
      },
      onSaved: (String value) {
        _formdata['email'] = value;
      },
    );
  }

  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _passwordTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelText: 'PASSWORD',
        hintText: '..............',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        border: UnderlineInputBorder(),
        icon: Icon(
          Icons.lock,
          color: Colors.black,
        ),
        suffixIcon: GestureDetector(
          onTap: _showPassword,
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
      obscureText: _obscureText,
      validator: (String value) {
        if (value.isEmpty || value.length <= 6) {
          return 'invalid password';
        }
      },
      onSaved: (String value) {
        _formdata['password'] = value;
      },
    );
  }

  _forgetPasswordDalog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Forgotten your password?'),
            content: _emailTextfield(),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('REST'),
                onPressed: () {},
              )
            ],
          );
        });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getuser().then((user) {
  //     if (user != null) {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (BuildContext context) => MusicPage()));
  //     }
  //   });
  // }

  // Future<FirebaseUser> getuser() async {
  //   return await _auth.currentUser();
  // }

  Future<void> _submitButton() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _formdata['email'], password: _formdata['password']);
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MusicPage()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Opps!!!'),
                content: Text('سجل و تعالي '),
                actions: <Widget>[
                  FlatButton(
                    child: Text('okey'),
                    onPressed: Navigator.of(context).pop,
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print(e.message);
    }
  }

// sign with google
  Future<void> googleSign() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential  = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
  print("signed in " + user.displayName);
  return user;
    // if (user != null) {
    // //   Navigator.push(context,
    // //       MaterialPageRoute(builder: (BuildContext context) => MusicPage()));
    // // }
  }

// Future<String> _signInWithGoogle() async {
//   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth =
//   await googleUser.authentication;
//   final AuthCredential user = GoogleAuthProvider.getCredential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//   assert(user.email != null);
//   assert(user.displayName != null);
//   assert(!user.isAnonymous);
//   assert(await user.getIdToken() != null);
// return 'signInWithGoogle succeeded: $user';
// }
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.black, fontSize: 28.0, fontFamily: 'Pacifico'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            // autovalidate: _autoValidate,
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontFamily: 'Pacifico'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 40.0),
                          child: GestureDetector(
                            
                            onTap: () {},
                            
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: new Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              // _handleSignIn();
                              googleSign();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: new Icon(
                                FontAwesomeIcons.google,
                                color: Colors.blueAccent[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: 100.0,
                          height: 1.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Text(
                            "Or",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontFamily: "Pacifico"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          width: 100.0,
                          height: 1.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _emailTextfield(),
                    SizedBox(
                      height: 15,
                    ),
                    _passwordTextfield(),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      child: Text('Foeget your password?'),
                      onPressed: _forgetPasswordDalog,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //=======================
            Expanded(
              child: MaterialButton(
                color: Colors.teal[300],
                elevation: 0,
                onPressed: _submitButton,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
