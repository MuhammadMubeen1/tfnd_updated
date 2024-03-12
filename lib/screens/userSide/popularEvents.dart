import 'package:flutter/material.dart';

class popularEvents extends StatefulWidget {
  const popularEvents({super.key});

  @override
  State<popularEvents> createState() => _popularEventsState();
}

class _popularEventsState extends State<popularEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Popular"),
      ),
    );
  }
}
