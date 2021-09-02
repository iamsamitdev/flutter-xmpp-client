import 'package:tap_chat/chat/chat.dart';
import 'package:tap_chat/connection/chat_center.dart';
import 'package:tap_chat/connection/messages_center.dart';
import 'package:tap_chat/connection/user_creditionals.dart';
import 'package:tap_chat/utils/constant.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class XmppConnection {
  UserCreditionals _userCreditionals;
  xmpp.Connection connection;
  MessageCenter _messageCenter;
  ChatCenter chatCenter;

  XmppConnection(this._userCreditionals);

  void connect() {
    var jid = xmpp.Jid.fromFullJid(_userCreditionals.jid);
    var account = xmpp.XmppAccountSettings(_userCreditionals.jid, jid.local,
        jid.domain, _userCreditionals.password, xmpp_port,
        host: xmpp_host);
    connection = xmpp.Connection(account);
    connection.connect();
    chatCenter = ChatCenter(connection, _userCreditionals);
  }

  void startMessageListen(Function(Chat) onAddChat) {
    _messageCenter = MessageCenter(connection);
    chatCenter.subscribeOnChats((chat) => {addChat(onAddChat, chat)});
  }

  void addChat(Function(Chat) onAddChat, xmpp.Chat chat) {
    print('Message received: ${chat.jid.domain}');
    _messageCenter.subscribeOn(chat.jid, onAddChat(Chat(chat)));
  }

  void subscribeOnUser(xmpp.Jid jid, Function(xmpp.Message) onRecieve) {
    _messageCenter.subscribeOn(jid, onRecieve);
  }

  bool isConnected() {
    return connection.isOpened();
  }

  xmpp.Connection GetConnection() {
    return connection;
  }
}
