import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'global.dart';
import 'meal.dart';
import 'user.dart';

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
      body: <Widget>[_mealsBody(meals), _userBody()][_navIndex],
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

Widget _mealsBody(meals) {
  return Center(
    child: ListView.builder(
      itemCount: meals.length,
      itemBuilder: (BuildContext context, int index) {
        return MealWidget(
          meal: meals[index],
        );
      },
    ),
  );
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
