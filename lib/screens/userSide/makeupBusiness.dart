import 'package:flutter/material.dart';

class makeupBusiness extends StatefulWidget {
  const makeupBusiness({super.key});

  @override
  State<makeupBusiness> createState() => _makeupBusinessState();
}

class _makeupBusinessState extends State<makeupBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Makeup"),
      ),
    );
  }
}
