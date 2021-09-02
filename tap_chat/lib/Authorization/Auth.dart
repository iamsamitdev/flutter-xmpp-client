import 'package:flutter/material.dart';
import 'package:tap_chat/Authorization/ExampleConnectionStateChangedListener.dart';
import 'package:tap_chat/connection/user_creditionals.dart';
import 'package:tap_chat/connection/xmpp_connection.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginIn extends StatefulWidget {
  LoginIn({Key key}) : super(key: key);

  @override
  Auth createState() => Auth();
}

class Auth extends State<LoginIn> {
  String login = "";
  String pass = "";

  changeLogin(String text) {
    setState(() => login = text);
  }

  changePass(String text) {
    setState(() => pass = text);
  }

//authorization method
  checkUser() async {

    print('$login + $pass');

    var user = UserCreditionals();
    user.SetUser(login, pass);
    var conn = XmppConnection(user);
    conn.connect();
    ExampleConnectionStateChangedListener(conn, context);

  }

//checking if the user is already logged in
  checkUserIsLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserLoggedIn = (prefs.getBool('isUserLoggedIn') ?? false);
    if (isUserLoggedIn) {
      var user = UserCreditionals();
      user.SetUser(login, pass);
      var conn = XmppConnection(user);
      conn.connect();
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  MyHomePage("AAA", conn)));
    }
  }

  //performance
  @override
  Widget build(BuildContext context) {
    checkUserIsLogin(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Login to Openfire',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 300,
              child: TextField(
                onChanged: changeLogin,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Login',
                  hintText: 'user@hostname'
                ),
              ),
            ),
            new Container(
              width: 300,
              child: TextField(
                onChanged: changePass,
                obscureText: true,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 25.0),
              child: new MaterialButton(
                color: Theme.of(context).accentColor,
                height: 50.0,
                minWidth: 150.0,
                child: new Text(
                  "LOGIN",
                ),
                onPressed: () => {checkUser()},
              ),
            )
          ],
        ),
      ),
    );
  }
}
