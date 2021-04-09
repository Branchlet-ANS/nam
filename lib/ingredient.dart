import 'data_enum.dart' as de;
import 'data.dart';

class Ingredient {
  List<dynamic> ingredient;
  double _mass;

  Ingredient(this.ingredient, {mass = 100.0}) {
    _mass = mass;
  }

  double getNutrientValue(de.Column column) {
    if (![de.Column.ID, de.Column.Name, de.Column.Category].contains(column) &&
        column.index % 2 == 0) {
      return ingredient[column.index] * _mass / 100;
    } else {
      throw new FormatException(
          "ID, Name, Category and Reference are not nutrient values.");
    }
  }

  double getMass() {
    return _mass;
  }

  void setMass(double mass) {
    _mass = mass;
  }

  String getName() {
    return ingredient[de.Column.Name.index];
  }

  dynamic getAttribute(de.Column column) {
    return ingredient[column.index];
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
