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

void main() async {
  String csv = await readFile(dataPath);
  data = const CsvToListConverter().convert(csv, textDelimiter: ';');
  print(data.length);
  for (List row in data) {
    for (String column in row) {
      print(column);
    }
  }
}

List<String> search(String name) {
  int index =
      data.indexWhere((row) => (row[DataEnum.Name.index].contains[name]));
  return data[index];
}
