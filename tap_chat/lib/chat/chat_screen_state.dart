import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tap_chat/views/theme_colors.dart';
import 'package:tap_chat/views/loading.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

import 'chat_screen.dart';
import 'package:toast/toast.dart';

class ChatScreenState extends State<ChatScreen> {
  List<xmpp.Message> listMessage = <xmpp.Message>[];

  bool isLoading;
  bool isShowSticker;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    isLoading = false;
    isShowSticker = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Communication с ${widget.chat.from.userAtDomain}',
            style: TextStyle(
                color: ThemeColors.lightGrey, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        // ignore: missing_required_param
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // Sticker
                  (isShowSticker ? buildSticker() : Container()),

                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          // onWillPop: onBackPress, // only for android
        ));
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      widget.chat.sendMessage(content);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      // Sending a message
    } else {
      _showToast('Nothing to send :(');
    }
  }

  void _showToast(String text) {
    Toast.show(text, context, duration: 2, gravity: Toast.BOTTOM);
  }

  Widget buildItem(int index, xmpp.Message message) {
    if (message.from.userAtDomain == widget.user.jid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          !_isGifImages(message.text)
              // Text
              ? Container(
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.red), // accent
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: ThemeColors.lightGrey,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              // Sticker
              : Container(
                  child: Image.asset(
                    'images/${message.text.replaceAll(RegExp('\{'), '').replaceAll(RegExp('\}'), '')}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(width: 35.0),
                !_isGifImages(message.text)
                    ? Container(
                        child: Text(
                          message.text,
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: ThemeColors.accent,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : Container(
                        child: Image.asset(
                          'images/${message.text.replaceAll(RegExp('\{'), '').replaceAll(RegExp('\}'), '')}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0),
                      ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('HH:mm:ss dd-MM-yyyy').format(message.time),
                      style: TextStyle(
                          color: ThemeColors.darkGrey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].from.userAtDomain == widget.user.jid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].from.userAtDomain != widget.user.jid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool _isGifImages(String value) {
    var gifs = ['{mimi1}'];
    return gifs.contains(value);
  }

  Widget buildSticker() {
    return Container(
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          TextButton(
              onPressed: () => onSendMessage('{mimi1}', 2),
              child: Image.asset(
                'images/mimi1.gif',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ))
        ])
      ]),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: ThemeColors.lightGrey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: ThemeColors.accent,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: ThemeColors.accent, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(color: ThemeColors.lightGrey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: ThemeColors.accent,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: ThemeColors.lightGrey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: widget.chat.messages.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ThemeColors.accent)))
          : StreamBuilder(
              stream: widget.chat.messageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeColors.accent)));
                } else {
                  if (!listMessage.any((mess) =>
                      mess.messageStanza.id == snapshot.data.messageStanza.id))
                    listMessage.insert(0, snapshot.data);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, listMessage[index]),
                    itemCount: listMessage.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
