import 'package:csc_picker/csc_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jnvapp/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';
import 'package:jnvapp/Widgets/PatternGenerate.dart';
import 'package:jnvapp/components/MyToast.dart';
import 'package:uuid/uuid.dart';

import '../../Services/FireStoreMethod.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';

class SetUpNavodhya extends StatefulWidget {
  const SetUpNavodhya({Key? key}) : super(key: key);

  @override
  State<SetUpNavodhya> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpNavodhya> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _passOutYearController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _schoolCampusController = TextEditingController();
  final TextEditingController _entryYearController = TextEditingController();
  final TextEditingController _entryClassController = TextEditingController();
  final TextEditingController _selectSectionController = TextEditingController();
  final TextEditingController _houseColorController = TextEditingController();

  Uuid uuid = Uuid();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _entryYearController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _passOutYearController.text = "${pickedDate.year}";
      });
    }
  }

  String? _validateInput(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 85.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add your",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Information and",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Navodhya Details",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              CSCPicker(
                defaultCountry:
                CscCountry.India, // Set default country to India

                layout: Layout.vertical,
                flagState: CountryFlag.ENABLE,
                onCountryChanged: (value) {
                  ToastUtil.showToastMessage('You Cannot Change Country');
                },
                onStateChanged: (value) {
                  setState(() {
                    _stateController.text = value ?? "";
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    _districtController.text = value ?? "";
                  });
                },
                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",
                countryDropdownLabel: "Select Country",
                stateDropdownLabel: "Select State",
                cityDropdownLabel: "Select City",
                dropdownDialogRadius: 12.0,
                searchBarRadius: 30.0,
                dropdownHeadingStyle: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                dropdownItemStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                ),
              ),
              MyTextField(
                controller: _schoolCampusController,
                hint: "Selection - School Campus",
                obscure: false,
                selection: true,
                preIcon: Icons.school,
                keyboardtype: TextInputType.text,
                validator: (value) =>
                    _validateInput(value, fieldName: 'School Campus'),
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                },
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: _entryYearController,
                    hint: "Entry Year",
                    obscure: false,
                    selection: true,
                    preIcon: Icons.calendar_today,
                    keyboardtype: TextInputType.datetime,
                    validator: (value) =>
                        _validateInput(value, fieldName: 'Entry Year'),
                  ),
                ),
              ),
              MyTextField(
                controller: _entryClassController,
                hint: "Entry Class",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Entry Class'),
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDate1(context);
                },
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: _passOutYearController,
                    hint: "Pass Out Year",
                    obscure: false,
                    selection: true,
                    preIcon: Icons.calendar_today,
                    keyboardtype: TextInputType.datetime,
                    validator: (value) =>
                        _validateInput(value, fieldName: 'Pass Out Year'),
                  ),
                ),
              ),
              MyTextField(
                controller: _rollNumberController,
                hint: "Roll Number",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Roll Number'),
              ),
              MyTextField(
                controller: _houseColorController,
                hint: "House",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.name,
              ),
              MyTextField(
                controller: _selectSectionController,
                hint: "Section",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.name,
              ),
              SizedBox(height: 15),
              MyButton(
                onTap: () async {
                  String? stateError =
                  _validateInput(_stateController.text, fieldName: 'State');
                  String? districtError = _validateInput(
                      _districtController.text,
                      fieldName: 'District');
                  String? campusError = _validateInput(
                      _schoolCampusController.text,
                      fieldName: 'School Campus');
                  String? yearError = _validateInput(_entryYearController.text,
                      fieldName: 'Entry Year');
                  String? classError = _validateInput(
                      _entryClassController.text,
                      fieldName: 'Entry Class');

                  if (stateError == null &&
                      districtError == null &&
                      campusError == null &&
                      yearError == null &&
                      classError == null) {

                    String data =
                    await rootBundle.loadString('Assets/csv/RTO.csv');
                    List<List<dynamic>> csvTable =
                    CsvToListConverter().convert(data);
                    String pattern = '';

                    // Iterate through each row in the CSV data
                    for (var row in csvTable) {
                      int currentIndex = 0;
                      for (var col in row) {
                        // Check if the searchData is present in the current column
                        if (col.toString().toLowerCase() ==
                            _districtController.text.toLowerCase()) {
                          // If searchData is found, print the data from the previous column (currentIndex - 1)
                          if (currentIndex > 0) {
                            print("N-" +
                                row[currentIndex - 1] +
                                _passOutYearController.text +
                                _rollNumberController.text);
                            pattern = "N-" +
                                row[currentIndex - 1] +
                                _passOutYearController.text +
                                _rollNumberController.text;
                            // print(currentIndex-1 );
                          } else {
                            print("No previous column exists.");
                          }
                          break; // Assuming searchData is unique in the row, exit loop if found
                        }

                        currentIndex++;
                      }
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          FireStoreMethods().NavodhyaData(
                            _stateController.text.trim(),
                            _districtController.text.trim(),
                            _selectSectionController.text.trim(),
                            _schoolCampusController.text.trim(),
                            _passOutYearController.text.trim(),
                            _entryClassController.text.trim(),
                            _entryYearController.text,
                            _houseColorController.text.trim(),
                            pattern,
                          );
                          return HomeScreen();
                        },
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all the fields correctly',
                        ),
                      ),
                    );
                  }
                },
                text: "Select And Continue",
                color: Color(0xFF888BF4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
