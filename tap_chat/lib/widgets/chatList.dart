import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tap_chat/chat/chat.dart';
import 'package:tap_chat/chat/chat_screen.dart';
import 'package:tap_chat/connection/chat_center.dart';

// ignore: must_be_immutable
class ChatList extends StatefulWidget {
  Chat chat;
  ChatCenter chatCenter;

  ChatList(this.chat, this.chatCenter);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToChat,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.chat.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.chat.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.chat.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.chat.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('HH:mm:ss dd-MM-yyyy').format(widget.chat.time),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.chat.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  void goToChat() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(widget.chat, widget.chatCenter)));
  }
}
