import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/user.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<User>(builder: (context, user, child) {
      return Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: ListView(
            children: [
              SizedBox(height: 100),
              Text("Name"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                      initialValue: user.getName(),
                      onChanged: (value) {
                        user.setName(value);
                      })),
              Text("Sex"),
              Container(
                  width: 100,
                  height: 100,
                  child: DropdownButton<bool>(
                    value: user.getSex(),
                    onChanged: (bool newValue) {
                      user.setSex(newValue);
                    },
                    items: <bool>[false, true]
                        .map<DropdownMenuItem<bool>>((bool value) {
                      return DropdownMenuItem<bool>(
                        value: value,
                        child: Text(value ? 'Male' : 'Female'),
                      );
                    }).toList(),
                  )),
              Text("Weight"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: user.getWeight().toString(),
                    onChanged: (value) => user.setWeight(double.parse(value)),
                  )),
              Text("Daily Kilocalories"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: user.getKilocalories().toString(),
                    onChanged: (value) {
                      user.setKilocalories(double.parse(value));
                    },
                  ))
            ],
          ));
    }));
  }
}
