import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final token;

  const HomePage({super.key, @required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Homepage')),
    );
  }
}
