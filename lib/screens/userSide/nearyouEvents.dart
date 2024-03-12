import 'package:flutter/material.dart';

class nearyouEvents extends StatefulWidget {
  const nearyouEvents({super.key});

  @override
  State<nearyouEvents> createState() => _nearyouEventsState();
}

class _nearyouEventsState extends State<nearyouEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Near You"),
      ),
    );
  }
}
