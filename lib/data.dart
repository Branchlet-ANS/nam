import 'package:csv/csv.dart';
import 'package:nam/ingredient.dart';
import 'data_enum.dart';

class Data {
  static List<List<dynamic>> data;
  List<Ingredient> ingredients;

  Data(dataString) {
    ingredients = [];
    data = CsvToListConverter().convert(dataString, fieldDelimiter: ';');
    manageData(data);
    for (List<dynamic> ingredientData in data) {
      ingredients.add(new Ingredient(ingredientData));
    }
  }

  manageData(List<List<dynamic>> data) {
    String currentTitle;
    List<List<dynamic>> titleRows = [];
    for (List<dynamic> row in data) {
      if (row[DataColumn.EdiblePart.index] == '') {
        currentTitle = row[DataColumn.Name.index];
        titleRows.add(row);
      }
      row[DataColumn.Category.index] = currentTitle;
    }
    for (List<dynamic> row in titleRows) {
      data.remove(row);
    }
    data[DataRow.Title.index][DataColumn.Category.index] = 'Kategori';
    data[DataRow.Unit.index][DataColumn.Category.index] = '.';
  }

  Iterable<Ingredient> search(String words,
      {DataColumn column = DataColumn.Name}) sync* {
    RegExp searchTerm = generateRegex(words);
    int i = 0;
    while (i != -1) {
      i = ingredients.indexWhere(
          (ingredient) => ingredient
              .getAttribute(column)
              .toLowerCase()
              .contains(searchTerm),
          i);
      if (i != -1) {
        yield ingredients[i++];
      }
    }
  }

  RegExp generateRegex(String _words) {
    _words = _words.toLowerCase();
    if (_words.length > 3 && _words.substring(0, 3) == 'rx:') {
      return new RegExp(_words.substring(3));
    }
    _words = _words.replaceAll(new RegExp(r'[^\w\s]+'), 'NONE_IDENTIFIER');
    List<String> words = _words.split(' ');
    String regex = '^((' + words.join('|') + ').*)+';
    return new RegExp(regex);
  }

  static String getTitle(DataColumn column) {
    return data[DataRow.Title.index][column.index];
  }

  static String getUnit(DataColumn column) {
    return data[DataRow.Unit.index][column.index];
  }
}
