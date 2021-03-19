class Meal {
  List<List<dynamic>> ingredients;
  Meal();

  Meal.from(Meal a, Meal b) {
    ingredients = (a.ingredients + b.ingredients).toSet().toList();
  }
  List<List<dynamic>> getIngredients() {
    return ingredients;
  }

  void addIngredient(List<dynamic> ingredient, double mass) {
    ingredients.add(ingredient);
  }
}
