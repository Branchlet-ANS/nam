import 'data.dart';
import 'user.dart';

class Global {
  static Data _data;
  static Recommended _recommended;
  static User _user;
  static int _navIndex = 0;

  static Data getData() {
    return _data;
  }

  static void setData(Data data) {
    _data = data;
  }

  static Recommended getRecommended() {
    return _recommended;
  }

  static void setRecommended(Recommended recommended) {
    _recommended = recommended;
  }

  static User getUser() {
    return _user;
  }

  static void setUser(User user) {
    _user = user;
  }

  static void setNavIndex(int navIndex) {
    _navIndex = _navIndex;
  }

  static int getNavIndex() {
    return _navIndex;
  }
}
