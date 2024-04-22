import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class PatternGenerate1 {
  void retrieveFirstColumnData(
      String searchData, String passwdoutYear, String Rollno) async {
    String data = await rootBundle.loadString('Assets/csv/RTO.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);
    String pattern = '';

    // Iterate through each row in the CSV data
    for (var row in csvTable) {
      int currentIndex = 0;
      for (var col in row) {
        // Check if the searchData is present in the current column
        if (col.toString().toLowerCase() == searchData.toLowerCase()) {
          // If searchData is found, print the data from the previous column (currentIndex - 1)
          if (currentIndex > 0) {
            print("N-" + row[currentIndex - 1] + passwdoutYear + Rollno);
            pattern = "N-" + row[currentIndex - 1] + passwdoutYear + Rollno;
            // print(currentIndex-1 );
          } else {
            print("No previous column exists.");
          }
          break; // Assuming searchData is unique in the row, exit loop if found
        }

        currentIndex++;
      }
    }

  }
}
