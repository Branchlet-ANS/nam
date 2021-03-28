import 'data_enum.dart';
import 'data.dart';

class Ingredient {
  List<dynamic> ingredient;
  double mass;

  Ingredient(this.ingredient, {this.mass = 100});

  double getNutrientValue(DataColumn column) {
    if (![DataColumn.ID, DataColumn.Name, DataColumn.Category]
            .contains(column) &&
        column.index % 2 == 0) {
      return ingredient[column.index] * mass / 100;
    } else {
      throw new FormatException(
          "ID, Name, Category and Reference are not nutrient values.");
    }
  }

  double getMass() {
    return mass;
  }

  String getName() {
    return ingredient[DataColumn.Name.index];
  }

  dynamic getAttribute(DataColumn column) {
    return ingredient[column.index];
  }

  @override
  String toString() {
    return getName();
  }

  String info({ref = false}) {
    String string = '';
    for (DataColumn column in DataColumn.values) {
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
