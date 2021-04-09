import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'global.dart';
import 'meal.dart';
import 'user.dart';
import 'data_enum.dart' as de;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.setUser(new User());
  String dataPath = 'assets/res/matvaretabellen.csv';
  Global.setData(new Data(await loadAsset(dataPath)));
  String recommendedPath = 'assets/res/table_1_8.csv';
  Global.setRecommended(new Recommended(await loadAsset(recommendedPath)));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Nam'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Meal> meals = [new Meal()];

  void _newMeal() {
    setState(() {
      meals.add(
        new Meal(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: <Widget>[_mealsBody(meals), _userBody()][Global.getNavIndex()],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: Global.getNavIndex(),
          onTap: (value) => setState(() => Global.setNavIndex(value)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User')
          ]),
      //drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _newMeal,
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _mealsBody(meals) {
  return Center(
      child: GestureDetector(
    onTap: () {
      //add code to change window
    },
    child: ListView.builder(
      itemCount: meals.length,
      itemBuilder: (BuildContext context, int index) {
        return MealWidget(
          meal: meals[index],
        );
      },
    ),
  ));
}

Widget _userBody() {
  return Center(
      child: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: ListView(
            children: [
              SizedBox(height: 100),
              Text("Name"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    initialValue: Global.getUser().getName(),
                    onFieldSubmitted: (value) =>
                        Global.getUser().setName(value),
                  )),
              Text("Sex"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    initialValue: Global.getUser().getSex() ? "Male" : "Female",
                    onFieldSubmitted: (value) =>
                        Global.getUser().setSex(value as bool),
                  )),
              Text("Weight"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    initialValue: Global.getUser().getWeight().toString(),
                    onFieldSubmitted: (value) =>
                        Global.getUser().setWeight(value as double),
                  )),
              Text("Daily Kilocalories"),
              Container(
                  width: 100,
                  height: 100,
                  child: TextFormField(
                    initialValue: Global.getUser().getKilocalories().toString(),
                    onFieldSubmitted: (value) =>
                        Global.getUser().setKilocalories(value as double),
                  ))
            ],
          )));
}

Widget _selectMassBody() {
  double mass = 0;
  return Center(
    child: ListView(
      children: [
        Text("Select mass:"),
        TextField(
          onSubmitted: (value) => mass = value as double,
        ),
        TextButton(
            onPressed: () {
              print("hello");
            },
            child: Text("Confirm"))
      ],
    ),
  );
}

Widget _mealBody(Meal meal) {
  List<int> mealValues = <int>[
    getNutrientPercentage(meal, de.Column.Iron, de.Row18.Iron),
    getNutrientPercentage(meal, de.Column.VitaminA, de.Row18.VitaminA),
    getNutrientPercentage(meal, de.Column.VitaminD, de.Row18.VitaminD)
  ];
  return Center(
      child: Column(children: [
    SizedBox(height: 100),
    Text("Meal"),
    Container(
        width: 350,
        height: 350,
        child: RadarChart.light(ticks: <int>[
          0,
          25,
          50,
          75,
          100
        ], features: <String>[
          "Jern",
          "Vit A",
          "Vit D",
        ], data: [
          mealValues
        ], reverseAxis: false, useSides: true))
  ]));
}

int getNutrientPercentage(meal, de.Column col, de.Row18 row) {
  return min(
      100,
      (100 *
              meal.getNutrientValue(col) /
              Recommended.getValue(row, de.Column18.AR_M))
          .round());
}
