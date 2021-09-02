import 'package:tap_chat/connection/user_creditionals.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ChatCenter {
  xmpp.Connection _connection;
  xmpp.ChatManager _chatManager;
  UserCreditionals userCreditionals;
  xmpp.MessageHandler _messageHandler;
  // ignore: unused_field
  xmpp.MessageArchiveManager _archiveManager;

  ChatCenter(this._connection, this.userCreditionals) {
    _chatManager = xmpp.ChatManager.getInstance(_connection);
    _messageHandler = xmpp.MessageHandler.getInstance(_connection);
    _archiveManager = xmpp.MessageArchiveManager.getInstance(_connection);
  }

  void subscribeOnChats(Function(xmpp.Chat) onNewChat) {
    _chatManager.chatListStream.listen((chats) {
      chats.forEach(onNewChat);
    });
  }

  xmpp.Chat getChat(xmpp.Jid jid) => _chatManager.getChat(jid);

  void sendMessageTo(xmpp.Jid jid, String message) {
    _messageHandler.sendMessage(jid, message);
  }
}
