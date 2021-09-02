import 'package:flutter/material.dart';
import 'package:tap_chat/chat/chat.dart';
import 'package:tap_chat/connection/chat_center.dart';
import 'package:tap_chat/widgets/chatList.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  List<Chat> _chats = <Chat>[];

  ChatCenter chatCenter;
  String filter = '';

  ChatPage(this.chatCenter);

  @override
  _ChatPageState createState() => _ChatPageState();

  Function(Chat) function;

  void addChat(Chat chat) {
    if (_chats.any((c) => c.from.fullJid == chat.from.fullJid)) return;
    _chats.add(chat);
    function(chat);
  }

  List<Chat> getFiltered() {
    return _chats
        .where((chat) => filter.isEmpty
            ? true
            : chat.from.userAtDomain
                .toLowerCase()
                .contains(filter.toLowerCase()))
        .toList();
  }
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.function = addChat;
    textController.addListener(_searchValues);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Chats",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 20, right: 20),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
              itemCount: widget.getFiltered().length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatList(widget.getFiltered()[index], widget.chatCenter);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _searchValues() {
    widget.filter = textController.text;
    setState(() {});
  }

  void addChat(Chat chat) {
    setState(() {
      print('Message received ${chat.name}');
    });
  }
}
