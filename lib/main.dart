import 'package:donorconnect/Pages/frontpage.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'Pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  runApp(MyApp(
    token: prefs.getString('token'),
  ));

}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    required this.token,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (token != null && !JwtDecoder.isExpired(token!))
          ? HomePage(token: token!)
          : const FrontPage(),
    );
  }
}
