import 'package:tap_chat/dto/contactDto.dart';
import 'package:xmpp_stone/xmpp_stone.dart';

mixin ContactPageDelegate {

  void UpdateState(List<Buddy> buddies);
  void UpdateSubscribers(ContactDto contactDto);
  
}