// @dart=2.9
import '../data/data_enum.dart' as de;
import '../data/data.dart';

class Ingredient {
  List<dynamic> _ingredient;
  double _mass = 0;

  Ingredient(this._ingredient, {mass = 100.0}) {
    _mass = mass;
  }

  Ingredient.from(Ingredient otherIngredient) {
    // Clone the internal data list, as it will be deleted by garbage collector otherwise
    _ingredient = new List<dynamic>.from(otherIngredient.getIngredientRaw());
    _mass = otherIngredient.getMass();
  }
  double getNutrientValue(de.Column column) {
    if (![de.Column.ID, de.Column.Name, de.Column.Category].contains(column) &&
        column.index % 2 == 0) {
      if (_ingredient[column.index] == 'M') {
        //todo: add code to notify that data is missing?
        return 0;
      }
      return _ingredient[column.index] * _mass / 100;
    } else {
      throw new FormatException(
          "ID, Name, Category and Reference are not nutrient values.");
    }
  }

  double getMass() {
    return _mass;
  }

  List<dynamic> getIngredientRaw() {
    return _ingredient;
  }

  void setMass(double mass) {
    _mass = mass;
  }

  String getName() {
    return _ingredient[de.Column.Name.index];
  }

  dynamic getAttribute(de.Column column) {
    return _ingredient[column.index];
  }

  @override
  String toString() {
    return getName();
  }

  String info({ref = false}) {
    String string = '';
    for (de.Column column in de.Column.values) {
      String s = Data.getTitle(column);
      if (getAttribute(column) != null && (ref || s != 'Ref')) {
        string += Data.getTitle(column) +
            ': ' +
            getAttribute(column).toString() +
            Data.getUnit(column) +
            '\n';
      }
    }
    return string;
  }
}
