import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_app/models/User.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isLoading = false;

  final _usernameFormKey = new GlobalKey<FormState>();
  final _passwordFormKey = new GlobalKey<FormState>();

  FocusNode _userNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  TextEditingController _userNameFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      if (_usernameFormKey.currentState.validate() &&
          _passwordFormKey.currentState.validate()) {
        // loginuser
        Future<User> userresponse =
            login(_userNameFieldController.text, _passwordFieldController.text);
        userresponse.then((user) => {
              //Navigate To Next Screen
            });
      }
    });
  }

  Future<User> login(String username, String password) {
    final JsonDecoder _decoder = new JsonDecoder();
    setLoadingTrue();

    return http.post("https://reqres.in/api/login", body: {
      "email": username,
      "password": password
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        dynamic respMap = json.decode(response.body);
        isLoadingFalse();
        User user = new User.mapToken(respMap);
        _showDialog("Success", "The user token is:" + user.token);
        return user;
      } else {
        isLoadingFalse();
        _showDialog(
            "Error", "Following status code returned from server: $statusCode");
//        throw new Exception("Error while fetching data");
      }
    });
  }

  void setLoadingTrue() {
    setState(() {
      _isLoading = true;
    });
  }

  void isLoadingFalse() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                    height: 100,
                    width: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _usernameFormKey,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _userNameFocusNode,
                        controller: _userNameFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: 'Username',
                          labelText: 'Username',
                        ),
                        onFieldSubmitted: (String value) {
                          _userNameFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        validator: (value) => _validateField(value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _passwordFormKey,
                      child: TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordFieldController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: 'Password',
                          labelText: 'Password',
                        ),
                        onFieldSubmitted: (String value) {
                          _passwordFocusNode.unfocus();
                        },
                        validator: (value) => _validateField(value),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: _incrementCounter,
                    color: Colors.blue[400],
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
    );
  }

  String _validateField(String value) {
    if (value.isEmpty) return 'This field is required';
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          elevation: 5,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
