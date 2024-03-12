import 'package:flutter/material.dart';

class upcomingEvents extends StatefulWidget {
  const upcomingEvents({super.key});

  @override
  State<upcomingEvents> createState() => _upcomingEventsState();
}

class _upcomingEventsState extends State<upcomingEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Upcoming"),
      ),
    );
  }
}
