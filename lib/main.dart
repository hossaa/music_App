import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_music/pages/configur.dart';
import './Log_Regis/login.dart';
import 'Log_Regis/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getuser().then((user) {
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MusicPage()));
      }
    });
  }
  
  Future<FirebaseUser> getuser() async {
    return await _auth.currentUser();
  }

  @override
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(.99), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Text(
                      'Yalla',
                      style: TextStyle(
                          color: Colors.blueGrey[200],
                          fontSize: 30.0,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Music',
                      style: TextStyle(
                          fontSize: 50.0,
                          color: Colors.blueGrey[200],
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //=======================
              Expanded(
                child: MaterialButton(
                  color: Colors.black,
                  elevation: 0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage(),
                            fullscreenDialog: true));
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.teal[100],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              //===============================
              Expanded(
                child: MaterialButton(
                  color: Colors.teal[300],
                  elevation: 0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage(),
                            fullscreenDialog: true));
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
