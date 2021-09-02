import 'package:tap_chat/connection/xmpp_connection.dart';
import 'package:tap_chat/contact/contactPageDelegate.dart';
import 'package:tap_chat/dto/contactDto.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ContactsHandler {
  xmpp.Connection _connection;

  ContactPageDelegate _contactPageDelegate;

  xmpp.RosterManager _rosterManager;

  // ignore: unused_field
  xmpp.PresenceManager _presenceManager;

  ContactsHandler(
      XmppConnection connection, ContactPageDelegate contactPageDelegate) {
    connection.connect();
    _connection = connection.connection;

    var presenceManager = xmpp.PresenceManager.getInstance(_connection);
    var rosterManager = xmpp.RosterManager.getInstance(_connection);
    var cardManager = xmpp.VCardManager.getInstance(_connection);

    _contactPageDelegate = contactPageDelegate;
    _rosterManager = rosterManager;
    _presenceManager = presenceManager;

    rosterManager.rosterStream.listen((streamEvent) {
      sendBuddies();
    });

    presenceManager.subscriptionStream.listen((streamEvent) {
      if (streamEvent.type == xmpp.SubscriptionEventType.REQUEST) {
        var vcard = cardManager.getVCardFor(streamEvent.jid);
        vcard.asStream().listen((event) {
          var contactDto = ContactDto(streamEvent.jid, event.nickName ?? streamEvent.jid.local, "");
          _contactPageDelegate.UpdateSubscribers(contactDto);
        });
      }
      if (streamEvent.type == xmpp.SubscriptionEventType.ACCEPTED) {}
      if (streamEvent.type == xmpp.SubscriptionEventType.DECLINED) {}
    });
  }

  void sendBuddies() {
    var buddies = _rosterManager.getRoster();
    _contactPageDelegate.UpdateState(buddies);
  }
}
