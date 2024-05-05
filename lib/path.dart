import 'package:flutter/material.dart';

class Path extends StatelessWidget {
  final color;
  Path({super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.all(12),
    );
  }
}
