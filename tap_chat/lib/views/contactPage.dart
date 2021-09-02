import 'package:flutter/material.dart';
import 'package:tap_chat/connection/chat_center.dart';
import 'package:tap_chat/connection/user_creditionals.dart';
import 'package:tap_chat/connection/xmpp_connection.dart';
import 'package:tap_chat/contact/contactPageDelegate.dart';
import 'package:tap_chat/contact/contactsHandler.dart';
import 'package:tap_chat/dto/contactDto.dart';
import 'package:tap_chat/models/contact.dart';
import 'package:tap_chat/views/theme_colors.dart';
import 'package:tap_chat/widgets/contactList.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

// ignore: must_be_immutable
class ContactPage extends StatefulWidget {
  XmppConnection connection;
  ChatCenter chatCenter;
  String filter = '';

  ContactPage(this.connection, this.chatCenter);
  @override
  _ContactPageState createState() => _ContactPageState(connection);
}

class _ContactPageState extends State<ContactPage> with ContactPageDelegate {
  bool _progressVisible = true;
  final textController = TextEditingController();

  _ContactPageState(XmppConnection connection) {
    var conn = new XmppConnection(UserCreditionals());
    var _ = new ContactsHandler(conn, this);
  }

  List<Contact> contacts = [];

  List<Contact> subscribers = [];

  List<Contact> getFilteredContacts() {
    return contacts
        .where((chat) => widget.filter.isEmpty
            ? true
            : chat.jid.userAtDomain
                .toLowerCase()
                .contains(widget.filter.toLowerCase()))
        .toList();
  }

  List<Contact> getFilteredSubscribers() {
    return subscribers
        .where((chat) => widget.filter.isEmpty
            ? true
            : chat.jid.userAtDomain
                .toLowerCase()
                .contains(widget.filter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
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
            getTitle(),
            getSearch(),
            getSubscribesList(),
            Divider(
              color: Colors.black,
            ),
            getContactList(),
            getProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  void UpdateState(List<Buddy> buddies) {
    setState(() {
      contacts = buddies
          .map((value) =>
              new Contact(value.jid, value.name, "lib/images/default.png"))
          .toList();
      _progressVisible = false;
    });
  }

  @override
  void UpdateSubscribers(ContactDto contactDto) {
    setState(() {
      var contact =
          Contact(contactDto.jid, contactDto.name, "lib/images/default.png");
      subscribers.add(contact);
    });
  }

  Widget getTitle() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Contacts",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ThemeColors.accent[50],
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: ThemeColors.accent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Add",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSearch() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 20, right: 20),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: ThemeColors.darkGrey),
          prefixIcon: Icon(
            Icons.search,
            color: ThemeColors.darkGrey,
            size: 20,
          ),
          filled: true,
          fillColor: ThemeColors.lightGrey,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: ThemeColors.lightGrey)),
        ),
      ),
    );
  }

  Widget getContactList() {
    return ListView.builder(
      itemCount: getFilteredContacts().length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ContactList(getFilteredContacts()[index], widget.chatCenter);
      },
    );
  }

  Widget getSubscribesList() {
    return ListView.builder(
      itemCount: getFilteredSubscribers().length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ContactList(getFilteredSubscribers()[index], widget.chatCenter);
      },
    );
  }

  Widget getProgressIndicator() {
    return Visibility(
        visible: _progressVisible,
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ));
  }

  void _searchValues() {
    widget.filter = textController.text;
    setState(() {});
  }
}
