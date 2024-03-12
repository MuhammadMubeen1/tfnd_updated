import 'package:flutter/material.dart';

class fitnessBusiness extends StatefulWidget {
  const fitnessBusiness({super.key});

  @override
  State<fitnessBusiness> createState() => _fitnessBusinessState();
}

class _fitnessBusinessState extends State<fitnessBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Fitness"),
      ),
    );
  }
}
