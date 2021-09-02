import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class Chat {
  xmpp.Chat _chat;

  String get name => _chat.jid.fullJid;
  xmpp.Jid get from => _chat.jid;
  String get messageText => '';
  String get imageUrl => 'lib/images/default.png';
  DateTime get time => DateTime.now();
  bool get isMessageRead => true;
  List<xmpp.Message> get messages => _chat.messages;

  Stream<xmpp.Message> get messageStream => _chat.newMessageStream;

  Chat(this._chat);

  void sendMessage(String message) {
    _chat.sendMessage(message);
  }
}
