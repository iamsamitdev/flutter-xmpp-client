import 'package:xmpp_stone/xmpp_stone.dart';

class ContactDto {
  Jid jid;
  String name;
  String imageURL;
  ContactDto(this.jid, this.name, this.imageURL);
}
