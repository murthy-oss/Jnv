
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart' show rootBundle;
  import 'package:csv/csv.dart';
 
  class PattrenGenerate extends StatefulWidget {
    const PattrenGenerate({super.key});
 
    @override
    State<PattrenGenerate> createState() => _PattrenGenerateState();
  }
 
  class _PattrenGenerateState extends State<PattrenGenerate> {
    TextEditingController state=TextEditingController();
     TextEditingController campuscode=TextEditingController();
      TextEditingController passwdoutYear=TextEditingController();
       TextEditingController Rollno=TextEditingController();



    @override
    Widget build(BuildContext context) {

      
      return Scaffold(
 
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: state,
                decoration: InputDecoration(
                  hintText: 'enter State',
          
                ),
              ),
               TextField(
                controller: campuscode,
                decoration: InputDecoration(
                  hintText: 'enter Compus Code',
          
                ),
              ),
               TextField(
                controller: passwdoutYear,
                decoration: InputDecoration(
                  hintText: 'enter Passed Out Year',
          
                ),
              ),
               TextField(
                controller: Rollno,
                decoration: InputDecoration(
                  hintText: 'enter last 3 digits Roll number',
          
                ),
              ),
              Center(child:
               
              ElevatedButton(onPressed: ()async{
              //  print(campuscode.text);
                 retrieveFirstColumnData(campuscode.text);
              }, child: Text("Click")),),
            ],
          ),
        )
      )
      ;
    }
    
void retrieveFirstColumnData(String searchData) async {
  String data = await rootBundle.loadString('assets/csv/RTO.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

  // Iterate through each row in the CSV data
  for (var row in csvTable) {
     int currentIndex = 0;
    for (var col in row) {
      // Check if the searchData is present in the current column
      if (col == searchData) {
        // If searchData is found, print the data from the previous column (currentIndex - 1)
        if (currentIndex > 0) {
          print("N"+row[currentIndex - 1]+passwdoutYear.text+Rollno.text);
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