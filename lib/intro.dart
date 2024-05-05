import 'package:flutter/material.dart';
import 'package:game/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _Intro();
}

class _Intro extends State<Intro> {
  TextEditingController nameController = TextEditingController();
  void saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  name: nameController.text,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Enter your name'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              saveName();
            },
            child: Text('Save Name'),
          ),
        ]),
      ),
    );
  }
}
