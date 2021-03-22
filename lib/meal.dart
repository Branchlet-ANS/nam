import 'data_enum.dart';
import 'ingredient.dart';

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
  }

  double getNutrientValue(DataColumn number) {
    double sum = 0;
    if (ingredients.length > 0) {
      for (Ingredient ingredient in ingredients) {
        sum += ingredient.getNutrientValue(number);
      }
    }

    return sum;
  }
}
