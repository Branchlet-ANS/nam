import 'package:csv/csv.dart';
import 'package:nam/ingredient.dart';
import 'data_enum.dart' as de;

class Data {
  static List<List<dynamic>> _data;
  List<Ingredient> ingredients;

  Data(String dataString) {
    ingredients = [];
    _data = CsvToListConverter().convert(dataString, fieldDelimiter: ';');
    manageData(_data);
    for (List<dynamic> ingredientData in _data) {
      ingredients.add(new Ingredient(ingredientData));
    }
  }

  manageData(List<List<dynamic>> data) {
    String currentTitle;
    List<List<dynamic>> titleRows = [];
    for (List<dynamic> row in data) {
      if (row[de.Column.EdiblePart.index] == '') {
        currentTitle = row[de.Column.Name.index];
        titleRows.add(row);
      }
      row[de.Column.Category.index] = currentTitle;
    }
    for (List<dynamic> row in titleRows) {
      data.remove(row);
    }
    data[de.Row.Title.index][de.Column.Category.index] = 'Kategori';
    data[de.Row.Unit.index][de.Column.Category.index] = '.';
  }

  Iterable<Ingredient> search(String words,
      {de.Column column = de.Column.Name}) sync* {
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

  static String getTitle(de.Column column) {
    return _data[de.Row.Title.index][column.index];
  }

  static String getUnit(de.Column column) {
    return _data[de.Row.Unit.index][column.index];
  }
}

class Recommended {
  static List<List<dynamic>> _data;

  Recommended(String data) {
    _data = CsvToListConverter().convert(data, fieldDelimiter: ';');
  }

  static dynamic getValue(de.Row18 row, de.Column18 col) {
    if (_data == null ||
        col.index >= _data.length ||
        row.index >= _data[col.index].length) {
      return null;
    }
    return _data[row.index][col.index];
  }

  static String getUnit(de.Row18 row) {
    if (_data == null) {
      return '';
    }
    return _data[row.index][de.Column18.Unit.index];
  }
}
