// ignore: import_of_legacy_library_into_null_safe
import 'data/data.dart';
import 'data/user.dart';

class Global {
  static Data? _data;
  static Recommended? _recommended;
  static NamUser? _user;

  static Data? getData() {
    return _data;
  }

  static void setData(Data data) {
    _data = data;
  }

  static Recommended? getRecommended() {
    return _recommended;
  }

  static void setRecommended(Recommended recommended) {
    _recommended = recommended;
  }

  static NamUser? getUser() {
    return _user;
  }

  static void setUser(NamUser user) {
    _user = user;
  }
}
