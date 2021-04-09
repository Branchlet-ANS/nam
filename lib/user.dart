class User {
  String _name;
  bool _sex; // 0: Female, 1: Male
  double _weight;

  User();

  bool getSex() {
    return _sex;
  }

  void setSex(bool sex) {
    _sex = sex;
  }

  String getName() {
    return _name;
  }

  void setName(String name) {
    _name = name;
  }

  double getWeight() {
    return _weight;
  }

  void setWeight(double weight) {
    _weight = weight;
  }
}
