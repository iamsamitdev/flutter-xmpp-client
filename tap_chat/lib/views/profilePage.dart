import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StackDemo(),
    );
  }
}

class StackDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: Text(
                "Profiles",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
          ),
          Container(
            child: CircleAvatar(
              backgroundImage: AssetImage("lib/images/default.png"),
              maxRadius: 30,
            ),
          ),
          // background image and bottom contents
          Container(
            height: 200.0,
            color: Colors.orange,
            child: Center(
              child: Text('This could be your background picture'),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('Brief information about the employee'),
              ),
            ),
          ),
          // Profile image
        ],
      ),
    );
  }


  
}
