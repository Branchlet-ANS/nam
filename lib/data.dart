import 'dart:io';
import 'package:csv/csv.dart';
import 'dataEnum.dart';

class Data {
  String dataPath;
  List<List<dynamic>> data;
  String dataString;

  Data() {
    dataPath = 'assets/res/matvaretabellen.csv';
  }

  void init() async {
    String csv = dataString;
    data = const CsvToListConverter().convert(csv, fieldDelimiter: ';');
    manageTitles(data);
    for (List<dynamic> result in search("gjende kjeks")) {
      print(result[Column.Name.index]);
    }
  }

  Future<String> readFile(String path) async {
    return File(path).readAsString().then((String contents) {
      return contents;
    });
  }

  manageTitles(List<List<dynamic>> data) {
    String currentTitle;
    List<List<dynamic>> titleRows = [];
    for (List<dynamic> row in data) {
      if (row[Column.EdiblePart.index] == '') {
        currentTitle = row[Column.Name.index];
        titleRows.add(row);
      }
      row[Column.Category.index] = currentTitle;
    }
    for (List<dynamic> row in titleRows) {
      data.remove(row);
    }
    data[Row.Title.index][Column.Category.index] = 'Kategori';
    data[Row.Unit.index][Column.Category.index] = '.';
  }

  Iterable<List<dynamic>> search(String words, {int index = 1}) sync* {
    RegExp searchTerm = generateRegex(words);
    int i = 0;
    while (i != -1) {
      print(i);
      i = data.indexWhere(
          (row) => row[index].toLowerCase().contains(searchTerm), i);
      if (i != -1) {
        yield data[i++];
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

  String itemToString(List<dynamic> item, {ref = false}) {
    String string = '';
    for (Column column in Column.values) {
      if (item[column.index] != null &&
          (ref || data[Row.Title.index][column.index] != 'Ref')) {
        string += data[Row.Title.index][column.index] +
            ': ' +
            item[column.index].toString() +
            data[Row.Unit.index][column.index] +
            '\n';
      }
    }
    return string;
  }

  Iterable<String> searchString(String word, {int index = 1}) sync* {
    for (List<dynamic> item in search(word)) {
      yield item[Column.Name.index];
    }
  }

  void main() async {
    String csv = await readFile(dataPath);
    data = const CsvToListConverter().convert(csv, fieldDelimiter: ';');
    manageTitles(data);
    for (List<dynamic> result in search("mat")) {
      print(result[Column.Name.index]);
    }
  }
}
