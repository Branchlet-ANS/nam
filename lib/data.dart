import 'dart:io';
import 'package:csv/csv.dart';
import 'dataEnum.dart';

const String dataPath = '\\resources\\matvaretabellen.csv';
List<List<dynamic>> data;

Future<String> readFile(String path) async {
  return File(Directory.current.path + path)
      .readAsString()
      .then((String contents) {
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
  data[Row.Category.index][Column.Category.index] = 'Kategori';
  data[Row.Unit.index][Column.Category.index] = '.';
}

List<dynamic> search(String word, {int index = 1}) {
  int i = data.indexWhere(
      (row) => row[index].toLowerCase().contains(word.toLowerCase()));
  return data[i];
}

String toString(List<dynamic> item) {
  String string = '';
  for (Column column in Column.values) {
    if (item[column.index] != null) {
      string += data[Row.Title.index][column.index] +
          ': ' +
          item[column.index].toString() +
          data[Row.Unit.index][column.index] +
          '\n';
    }
  }
  return string;
}

void main() async {
  String csv = await readFile(dataPath);
  data = const CsvToListConverter().convert(csv, fieldDelimiter: ';');
  manageTitles(data);
  print(toString(search('geitmelk')));
}
