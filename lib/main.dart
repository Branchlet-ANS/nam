import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'meal.dart';
import 'search.dart';

Data data;
Recommended recommended;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  runApp(MyApp());
  String dataPath = 'assets/res/matvaretabellen.csv';
  data = new Data(await loadAsset(dataPath));
  String recommendedPath = 'assets/res/table_1_8.csv';
  recommended = new Recommended(await loadAsset(recommendedPath));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Nam'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(data))
                    .then((ingredient) => setState(() {
                          if (ingredient != null) {
                            meals.last.addIngredient(ingredient, 100);
                          }
                        }));
              })
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (BuildContext context, int index) {
            return MealWidget(
              meal: meals[index],
            );
          },
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
      ]),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _newMeal,
        child: Icon(Icons.add),
      ),
    );
  }
}
