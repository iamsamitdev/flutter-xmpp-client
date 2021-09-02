import 'package:flutter/material.dart';
import 'package:tap_chat/chat/chat.dart';
import 'package:tap_chat/chat/chat_screen.dart';
import 'package:tap_chat/connection/chat_center.dart';
import 'package:tap_chat/models/contact.dart';

// ignore: must_be_immutable
class ContactList extends StatefulWidget {
  Contact contact;
  ChatCenter chatCenter;

  ContactList(this.contact, this.chatCenter);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
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
                    backgroundImage: AssetImage(widget.contact.imageURL),
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
                            widget.contact.name ?? 'Без имени',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToChat() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(
            Chat(widget.chatCenter.getChat(widget.contact.jid)),
            widget.chatCenter)));
  }
}
