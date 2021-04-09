import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'global.dart';
import 'meal.dart';

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  runApp(MyApp());
  String dataPath = 'assets/res/matvaretabellen.csv';
  Global.setData(new Data(await loadAsset(dataPath)));
  String recommendedPath = 'assets/res/table_1_8.csv';
  Global.setRecommended(new Recommended(await loadAsset(recommendedPath)));
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
  int _navIndex = 0;

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
      body: <Widget>[
        Center(
          child: ListView.builder(
            itemCount: meals.length,
            itemBuilder: (BuildContext context, int index) {
              return MealWidget(
                meal: meals[index],
              );
            },
          ),
        ),
        Center(
            child: Column(
          children: [Text("User")],
        ))
      ][_navIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (value) => setState(() => _navIndex = value),
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
