import 'data.dart';

class Global {
  static Data _data;
  static Recommended _recommended;

  static Data getData() {
    return _data;
  }

  static void setData(data) {
    _data = data;
  }

  static getRecommended() {
    return _recommended;
  }

  static void setRecommended(recommended) {
    _recommended = recommended;
  }
}
