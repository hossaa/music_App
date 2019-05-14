import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_music/pages/configur.dart';
import './login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  // final Function googleSign;
  // RegisterPage(this.googleSign);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final Map<String, dynamic> _formdata = {
    'username': '',
    'email': '',
    'password': '',
    'firstname': '',
    'lastname': ''
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  // bool _success;

  Widget _userNameTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'UserName',
        hintText: 'Enter your username',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty || !RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
          return 'please Enter user name';
        }
      },
      onSaved: (String value) {
        _formdata['username'] = value;
      },
    );
  }

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
        if (value.isEmpty || value.length <= 8) {
          return 'invalid password';
        }
      },
      onSaved: (String value) {
        _formdata['password'] = value;
      },
    );
  }

  Widget _firsNameTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'FirstName',
        hintText: 'Enter your firstname',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty || !RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
          return 'please Enter firstname';
        }
      },
      onSaved: (String value) {
        _formdata['firstname'] = value;
      },
    );
  }

  Widget _lastNameTextfield() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'LastName',
        hintText: 'Enter your lastname',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        icon: Icon(
          Icons.person,
          color: Colors.black,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty || !RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
          return 'please Enter lastname';
        }
      },
      onSaved: (String value) {
        _formdata['lastname'] = value;
      },
    );
  }

  // Future<Map<String, dynamic>> signup(String userName, String password,
  //     String email, String firstName, String lastName) async {
  //   final Map<String, dynamic> authapp = {
  //     'userName': userName,
  //     'email': email,
  //     'password': password,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'returnSecureToken': true,
  //   };
  //   final http.Response response = await http.post(
  //     'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCda2grzwLtjFwpt-hmjl-WkqiQLzgb20w',
  //     body: json.encode(authapp),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   print(json.encode(response.body));
  //   return {'success': true, 'message': 'Authentcation success!'};
  // }

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
// signup methods
  Future _submitsginUp() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _formdata['email'], password: _formdata['password']);
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MusicPage()));
      }
    } catch (e) {
      print(e.message);
    }
  }
  // google signup methods 

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
            'Registration',
            style: TextStyle(
                color: Colors.black, fontSize: 30.0, fontFamily: 'Pacifico'),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: _formKey,
              // autovalidate: _autoValidate,
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Hello!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: 'Pacifico'),
                      ),
                      SizedBox(
                        height: 7,
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
                            //  googleSign();
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
                        height: 8,
                      ),
                      _userNameTextfield(),
                      SizedBox(
                        height: 15,
                      ),
                      _emailTextfield(),
                      SizedBox(
                        height: 15,
                      ),
                      _passwordTextfield(),
                      SizedBox(
                        height: 15,
                      ),
                      _firsNameTextfield(),
                      SizedBox(
                        height: 15,
                      ),
                      _lastNameTextfield(),
                    ],
                  ),
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
                onPressed: () {
                  _submitsginUp();
                },
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Register",
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
