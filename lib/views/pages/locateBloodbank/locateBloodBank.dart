import 'package:flutter/material.dart';

class LocateBloodbank extends StatefulWidget {
  const LocateBloodbank({super.key});

  @override
  State<LocateBloodbank> createState() => _LocateBloodbankState();
}

class _LocateBloodbankState extends State<LocateBloodbank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locate BloodBanks"),
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(),
      ),
    );
  }
}
