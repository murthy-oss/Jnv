import 'package:country_state_city/utils/country_utils.dart';
import 'package:country_state_city/utils/state_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:us_states/us_states.dart';

class PattrenGenerate extends StatefulWidget {
  const PattrenGenerate({super.key});

  @override
  State<PattrenGenerate> createState() => _PattrenGenerateState();
}

class _PattrenGenerateState extends State<PattrenGenerate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child: 
      
      ElevatedButton(onPressed: ()async{
    // Get all countries
final countries = await getAllCountries();

// Get all states that belongs to a country by country ISO CODE
final states = await getStatesOfCountry('AF'); // Afghanistan
print(states);

      }, child: Text("Click")),)
    )
    ;
  }
}