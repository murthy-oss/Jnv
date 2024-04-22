
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../AuthScreens/HomePage.dart';
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
  final TextEditingController _rollNumber = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _schoolCampusController = TextEditingController();
  final TextEditingController _entryYearController = TextEditingController();
  final TextEditingController _entryClassController = TextEditingController();
  String _selectSection = '';
  String _houseColorController = '';
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
              MyTextField(
                controller: _stateController,
                hint: "Selection - State",
                obscure: false,
                selection: true,
                preIcon: Icons.location_on,
                keyboardtype: TextInputType.text,
                validator: (value) => _validateInput(value, fieldName: 'State'),
              ),
              MyTextField(
                controller: _districtController,
                hint: "Selection - District",
                obscure: false,
                selection: true,
                preIcon: Icons.location_city,
                keyboardtype: TextInputType.text,
                validator: (value) =>
                    _validateInput(value, fieldName: 'District'),
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
              MyTextField(
                controller: _entryYearController,
                hint: "Entry Year",
                obscure: false,
                selection: true,
                preIcon: Icons.date_range,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Entry Year'),
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
                  await _selectDate(context);
                },
                child: AbsorbPointer(
                  child: MyTextField(
                    controller: _passOutYearController,
                    hint: "Date of Birth",
                    obscure: false,
                    selection: true,
                    preIcon: Icons.calendar_today,
                    keyboardtype: TextInputType.datetime,
                    validator: (value) =>
                        _validateInput(value, fieldName: 'Date of Birth'),
                  ),
                ),
              ),
              MyTextField(
                controller: _rollNumber,
                hint: "Roll Number",
                obscure: false,
                selection: true,
                preIcon: Icons.class_,
                keyboardtype: TextInputType.number,
                validator: (value) =>
                    _validateInput(value, fieldName: 'Entry Class'),
              ),


              SizedBox(height: 15),
              MyButton(
                onTap: () {
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
                  String? RollNumberError = _validateInput(_rollNumber.text,
                      fieldName: 'House Color');
                  if (stateError == null &&
                      districtError == null &&
                      campusError == null &&
                      yearError == null &&
                      classError == null &&
                      RollNumberError == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          FireStoreMethods().NavodhyaData(
                            _stateController.text.trim(),
                            _districtController.text.trim(),
                            _selectSection,
                            _schoolCampusController.text.trim(),
                            _passOutYearController.text.trim(),
                            _entryClassController.text.trim(),
                            _entryYearController.text,
                            _houseColorController,
                          );
                          return HomePage();
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
