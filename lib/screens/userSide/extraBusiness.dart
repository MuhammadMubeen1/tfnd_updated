import 'package:flutter/material.dart';

class extraBusiness extends StatefulWidget {
  const extraBusiness({super.key});

  @override
  State<extraBusiness> createState() => _extraBusinessState();
}

class _extraBusinessState extends State<extraBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Extra"),
      ),
    );
  }
}
