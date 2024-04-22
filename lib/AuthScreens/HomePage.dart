import 'package:flutter/material.dart';
import 'package:jnvapp/services/AuthFunctions.dart';
import 'package:jnvapp/AuthScreens/LoginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
      title: Center(child: Text("Home Page")),
      ),
      body:Center(
        child: ElevatedButton(onPressed: (){
          AuthService.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
        }, child: Text("Log Out")),
      ),
    );
  }
}