import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meal.dart';

class MealsPage extends StatefulWidget {
  MealsPage({Key key}) : super(key: key);

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: GestureDetector(
      child: Consumer<MealList>(
        builder: (context, mealList, child) {
          return Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: mealList.length(),
                  itemBuilder: (BuildContext context, int index) {
                    return MealWidget(
                        meal: mealList.getMeal(index), mealList: mealList);
                  }),
            ),
            TextButton(
                onPressed: () => mealList.addMeal(new Meal()),
                child: Text("New meal"))
          ]);
        },
      ),
    ));
  }
}
