import 'package:nam/data.dart';

import 'data_enum.dart' as de;
import 'ingredient.dart';
import 'package:flutter/material.dart';

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
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.meal.toString(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Protein: ' +
                    widget.meal.getNutrientValue(de.Column.Protein).toString(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Carbs: ' +
                    widget.meal
                        .getNutrientValue(de.Column.Carbohydrate)
                        .toString(),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Mass: ' + widget.meal.getMass().toString()),
              SizedBox(
                height: 10,
              ),
              nutrient(de.Column.VitaminA, de.Row18.VitaminA),
              SizedBox(
                height: 10,
              ),
              nutrient(de.Column.Iron, de.Row18.Iron),
              SizedBox(
                height: 10,
              ),
              nutrient(de.Column.Calcium, de.Row18.Calcium),
              SizedBox(
                height: 10,
              ),
              nutrient(de.Column.Potassium, de.Row18.Potassium),
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
