class Ingredient {
  List<dynamic> ingredient;
  double mass;

  Ingredient(this.ingredient, this.mass);

  double getNutrientValue(number) {
    return ingredient[number] * mass / 100;
  }
}
