import 'package:flutter/material.dart';
import 'package:nam/ingredient.dart';
import 'data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'meal.dart';
import 'search.dart';
import 'data_enum.dart' as de;

Data data;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  runApp(MyApp());
  String dataPath = 'assets/res/matvaretabellen.csv';
  data = new Data(await loadAsset(dataPath));
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

class MealWidget extends StatefulWidget {
  const MealWidget({Key key, this.meal}) : super(key: key);
  final Meal meal;

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'En godting.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Protein: ' +
                    widget.meal
                        .getNutrientValue(de.DataColumn.Protein)
                        .toString(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Carbs: ' +
                    widget.meal
                        .getNutrientValue(de.DataColumn.Carbohydrate)
                        .toString(),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Mass: ' + widget.meal.getMass().toString())
            ]),
      ),
    );
  }
}
