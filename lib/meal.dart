import 'package:nam/data.dart';
import 'data_enum.dart' as de;
import 'ingredient.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import 'global.dart';

class Meal {
  List<Ingredient> ingredients = [];
  Meal();

  Meal.from(Meal a, Meal b) {
    ingredients = (a.ingredients + b.ingredients);
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }

  void addIngredient(Ingredient ingredient, double mass) {
    ingredient.setMass(mass);
    ingredients.add(ingredient);
  }

  double getMass() {
    double mass = 0;
    for (Ingredient i in ingredients) {
      mass += i.getMass();
    }
    return mass;
  }

  double getNutrientValue(de.Column number) {
    double sum = 0;
    for (Ingredient ingredient in ingredients) {
      sum += ingredient.getNutrientValue(number);
    }
    return sum;
  }

  String toString() {
    String string = 'Meal of: ';
    for (Ingredient ingredient in ingredients) {
      string += ingredient.getName() + ", ";
    }
    return string;
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
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Text(
            widget.meal.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(Global.getData()))
                    .then((ingredient) => setState(() {
                          if (ingredient != null) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return SelectMassPage(widget.meal, ingredient);
                            }));
                          }
                        }));
              })
        ]),
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
        child: ListView(
          children: [
            Text("Select mass:"),
            Container(
              child: TextFormField(
                initialValue: mass.toString(),
                onFieldSubmitted: (value) {
                  setState(() {
                    mass = double.parse(value);
                  });
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  widget.meal.addIngredient(widget.ingredient, mass);
                  Navigator.pop(context);
                },
                child: Text("Confirm"))
          ],
        ),
      ),
    );
  }
}
