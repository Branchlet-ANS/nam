class User {
  bool _sex; // 0: Female, 1: Male

  User(this._sex);

  void setSex(bool sex) {
    _sex = sex;
  }

  bool getSex() {
    return _sex;
  }
}
