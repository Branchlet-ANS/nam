import 'dart:io';
import 'package:csv/csv.dart';

const String dataPath = '\\resources\\matvaretabellen.csv';

String readFile(String path) {
  String contents;
  File(Directory.current.path + path).readAsString().then((String _contents) {
    contents = _contents;
  });
  return contents;
}

void main() async {
  String csv = readFile(dataPath);
  List<List<dynamic>> data = const CsvToListConverter().convert(csv);
  for (List row in data) {
    for (String column in row) {
      print(column);
    }
  }
}
