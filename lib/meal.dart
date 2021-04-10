import 'dart:math';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:nam/data.dart';
import 'package:provider/provider.dart';
import 'data_enum.dart' as de;
import 'ingredient.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'global.dart';

class Meal extends ChangeNotifier {
  List<Ingredient> ingredients = [];
  List<MealList> mealListListeners = [];
  String _name = 'Måltid';
  Meal();

  Meal.from(Meal a, Meal b) {
    ingredients = (a.ingredients + b.ingredients);
  }

  void setName(name) {
    _name = name;
    notifyListeners();
  }

  String getName() {
    return _name;
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(Ingredient ingredient) {
    ingredients.remove(ingredient);
    notifyListeners();
  }

  double getMass() {
    double mass = 0;
    for (Ingredient i in ingredients) {
      mass += i.getMass();
    }
    return mass;
  }

  void addMealListListener(MealList listener) {
    mealListListeners.add(listener);
  }

  void removeMealListListener(MealList listener) {
    mealListListeners.remove(listener);
  }

  @override
  void notifyListeners() {
    for (MealList listener in mealListListeners) {
      listener.update();
    }
    super.notifyListeners();
  }

  double getNutrientValue(de.Column number) {
    double sum = 0;
    for (Ingredient ingredient in ingredients) {
      sum += ingredient.getNutrientValue(number);
    }
    return sum;
  }

  String toString() {
    String string = '';
    for (Ingredient ingredient in ingredients) {
      string +=
          ingredient.getMass().toString() + 'g ' + ingredient.getName() + '\n';
    }
    return string;
  }
}

class MealWidget extends StatefulWidget {
  const MealWidget({Key key, this.meal, this.mealList}) : super(key: key);
  final Meal meal;
  final MealList mealList;

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return MealPage(widget.meal);
          }),
        )
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Row(
                children: [
                  Text(
                    widget.meal.getName(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(Icons.pie_chart),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return MealPage(widget.meal);
                        }));
                      })
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
            Text(widget.meal.toString(),
                style: TextStyle(fontStyle: FontStyle.italic)),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showSearch(
                          context: context, delegate: Search(Global.getData()))
                      .then((ingredient) => setState(() {
                            if (ingredient != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return SelectMassPage(
                                    widget.meal, // Make a copy of ingredient
                                    new Ingredient.from(ingredient));
                              }));
                            }
                          }));
                })
          ]),
        ),
      ),
    );
  }

  Widget nutrient(de.Column col, de.Row18 row) {
    return Text(Data.getTitle(col) +
        ': ' +
        widget.meal.getNutrientValue(col).toString() +
        ' / ' +
        Recommended.getValue(row, de.Column18.AR_M).toString() +
        ' ' +
        Recommended.getUnit(row));
  }
}

class SelectMassPage extends StatefulWidget {
  final Meal meal;
  final Ingredient ingredient;

  SelectMassPage(this.meal, this.ingredient);

  @override
  State<StatefulWidget> createState() => _SelectMassPageState();
}

class _SelectMassPageState extends State<SelectMassPage> {
  double mass = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 300,
        height: 300,
        child: ListView(
          children: [
            Text("Select mass:"),
            SizedBox(
              height: 20,
            ),
            Container(
                child: TextFormField(
              initialValue: mass.toString(),
              onChanged: (value) => {mass = double.parse(value)},
            )),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () => setState(() {
                      widget.ingredient.setMass(mass);
                      widget.meal.addIngredient(widget.ingredient);
                      Navigator.pop(context);
                    }),
                child: Text("Confirm"))
          ],
        ),
      ),
    ));
  }
}

class MealList extends ChangeNotifier {
  List<Meal> _meals = [];

  void addMeal(Meal meal) {
    _meals.add(meal);
    meal.addMealListListener(this);
    notifyListeners();
  }

  void removeMeal(Meal meal) {
    if (_meals.contains(meal)) {
      _meals.remove(meal);
      meal.removeMealListListener(this);
      notifyListeners();
    }
  }

  Meal getMeal(int index) {
    return _meals[index];
  }

  int length() {
    return _meals.length;
  }

  void update() {
    notifyListeners();
  }
}

class MealPage extends StatefulWidget {
  final Meal meal;

  MealPage(this.meal);

  @override
  State<StatefulWidget> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    List<int> getMealValues() {
      return <int>[
        getNutrientPercentage(
            widget.meal, de.Column.VitaminA, de.Row18.VitaminA),
        getNutrientPercentage(
            widget.meal, de.Column.VitaminC, de.Row18.VitaminC),
        getNutrientPercentage(
            widget.meal, de.Column.VitaminD, de.Row18.VitaminD),
        getNutrientPercentage(
            widget.meal, de.Column.VitaminE, de.Row18.VitaminE),
        getNutrientPercentage(widget.meal, de.Column.Iron, de.Row18.Iron),
        getNutrientPercentage(widget.meal, de.Column.Zink, de.Row18.Zinc),
        getNutrientPercentage(widget.meal, de.Column.Iodine, de.Row18.Iodine),
        getNutrientPercentage(
            widget.meal, de.Column.Kilocalories, de.Row18.Kilocalories),
        getNutrientPercentage(
            widget.meal, de.Column.VitaminB6, de.Row18.VitaminB6)
      ];
    }

    return ChangeNotifierProvider.value(
        value: widget.meal,
        child: Consumer<Meal>(builder: (context, meal, child) {
          return meal == null
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  body: Center(
                      child: Column(children: [
                  SizedBox(height: 100),
                  Container(
                    width: 400,
                    padding: EdgeInsets.all(40),
                    child: TextFormField(
                        initialValue: meal.getName(),
                        onChanged: (value) => {meal.setName(value)}),
                  ),
                  Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: meal.getIngredients().length,
                          itemBuilder: (BuildContext context, int index) {
                            return IngredientWidget(
                              meal: meal,
                              ingredient: meal.getIngredients()[index],
                            );
                          })),
                  Container(
                      width: 350,
                      height: 350,
                      child: RadarChart.light(ticks: <int>[
                        25,
                        50,
                        75,
                        100
                      ], features: <String>[
                        'Vit A',
                        'Vit C',
                        'Vit D',
                        'Vit E',
                        'Jern',
                        'Zink',
                        'Jod',
                        'Kcal',
                        'Vit B6'
                      ], data: [
                        getMealValues()
                      ], reverseAxis: false, useSides: true)),
                  TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Text("Fuck this"))
                ])));
        }));
  }
}

int getNutrientPercentage(meal, de.Column col, de.Row18 row) {
  return min(
      100,
      (100 *
              meal.getNutrientValue(col) /
              Recommended.getValue(row, de.Column18.AR_M))
          .round());
}

class IngredientWidget extends StatefulWidget {
  const IngredientWidget({Key key, this.meal, this.ingredient})
      : super(key: key);
  final Meal meal;
  final Ingredient ingredient;

  @override
  _IngredientWidgetState createState() => _IngredientWidgetState();
}

class _IngredientWidgetState extends State<IngredientWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
              width: 400,
              child: Text(widget.ingredient.getMass().toString() +
                  ' g ' +
                  widget.ingredient.getName())),
          IconButton(
              icon: Icon(Icons.remove),
              onPressed: () =>
                  {widget.meal.removeIngredient(widget.ingredient)})
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center);
  }
}
