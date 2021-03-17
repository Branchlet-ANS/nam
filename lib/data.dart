import 'dart:io';
import 'package:csv/csv.dart';

const String dataPath = '\\resources\\matvaretabellen.csv';

Future<String> readFile(String path) async {
  return File(Directory.current.path + path)
      .readAsString()
      .then((String contents) {
    return contents;
  });
}

void main() async {
  String csv = await readFile(dataPath);
  List<List<dynamic>> data =
      const CsvToListConverter().convert(csv, textDelimiter: ';');
  print(data.length);
  for (List row in data) {
    for (String column in row) {
      print(column);
    }
  }
}
