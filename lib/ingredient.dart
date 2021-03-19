import 'dataEnum.dart';

class Ingredient {
  List<dynamic> ingredient;
  double mass;

  Ingredient(this.ingredient, this.mass);

  double getNutrientValue(Column number) {
    if (![Column.ID, Column.Name, Column.Category].contains(number) &&
        number.index % 2 == 0) {
      return ingredient[number.index] * mass / 100;
    } else {
      throw new FormatException(
          "Name, Column, Category, Reference are not nutrient values.");
    }
  }

  String getName() {
    return ingredient[Column.Name.index];
  }
}
