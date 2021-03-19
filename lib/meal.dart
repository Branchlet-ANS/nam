import 'dataEnum.dart';
import 'ingredient.dart';

class Meal {
  List<Ingredient> ingredients;
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

  double getNutrientValue(Column number) {
    double sum = 0;
    for (Ingredient ingredient in ingredients) {
      sum += ingredient.getNutrientValue(number);
    }
    return sum;
  }
}
