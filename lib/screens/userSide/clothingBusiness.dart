import 'package:flutter/material.dart';

class clothingBusiness extends StatefulWidget {
  const clothingBusiness({super.key});

  @override
  State<clothingBusiness> createState() => _clothingBusinessState();
}

class _clothingBusinessState extends State<clothingBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Clothing"),
      ),
    );
  }
}
