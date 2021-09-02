import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class Contact {
  xmpp.Jid jid;
  String name;
  String imageURL;

  Contact(this.jid, this.name, this.imageURL);
}
