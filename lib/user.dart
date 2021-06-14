import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  String _name = "";
  bool _sex = false; // 0: Female, 1: Male
  double _weight = 69;
  double _kilocalories = 2000;

  User();

  bool getSex() {
    return _sex;
  }

  void setSex(bool sex) {
    _sex = sex;
    notifyListeners();
  }

  String getName() {
    return _name;
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  double getWeight() {
    return _weight;
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  double getKilocalories() {
    return _kilocalories;
  }

  void setKilocalories(double kilocalories) {
    _kilocalories = kilocalories;
    notifyListeners();
  }
}
