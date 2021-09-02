import 'package:flutter/material.dart';
import 'package:tap_chat/connection/xmpp_connection.dart';
import 'package:tap_chat/Authorization/Auth.dart';
import 'package:tap_chat/utils/constant.dart';
import 'package:tap_chat/views/contactPage.dart';
import 'package:tap_chat/views/profilePage.dart';

import 'views/chatPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: app_name,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginIn(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title, this.connection);

  final String title;
  final XmppConnection connection;

  @override
  _MyHomePageState createState() => _MyHomePageState(connection);
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
  XmppConnection _connection;
  ChatPage _chatPage;

  _MyHomePageState(this._connection);

  @override
  void initState() {
    super.initState();
    _connection.connect();
    _chatPage = ChatPage(_connection.chatCenter);
    _connection.startMessageListen(_chatPage.addChat);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      ContactPage(_connection, _connection.chatCenter),
      _chatPage,
      ProfilePage()
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: contact_tabmenu_text,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: chat_tabmenu_text,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: profile_tabmenu_text,
          ),
        ],
      ),
    );
  }
}
