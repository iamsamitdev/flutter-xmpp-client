import 'package:tap_chat/utils/constant.dart';

class UserCreditionals {
  static final UserCreditionals _singleton = UserCreditionals._internal();

  factory UserCreditionals() {
    return _singleton;
  }

  UserCreditionals._internal();
  String password;
  String userName;
  String get domain => xmpp_host;

  String get jid => '$userName';

  void SetUser(String login, String pass) {
    password = xmpp_pass; // pass;
    userName = xmpp_user; // login;
  }
}
