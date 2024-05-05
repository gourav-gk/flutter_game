import 'dart:async';
import 'package:game/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:game/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  late String storedName;
  bool isIntroSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween(begin: 0.0, end: 50.0).animate(animationController);

    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => isIntroSet
                  ? Home(
                      name: storedName,
                    )
                  : Intro()));
    });
    loadStoredName();
  }

  void loadStoredName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedName = prefs.getString('name') ?? '';
    if (storedName != '') {
      isIntroSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.deepPurple,
            child: Center(
              child: Text(
                'GAME',
                style:
                    TextStyle(fontSize: animation.value, color: Colors.white),
              ),
            )));
  }
}
