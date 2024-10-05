import 'package:donorconnect/cubit/profile_cubit.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:donorconnect/views/pages/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ProfileCubit())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (token != null && !JwtDecoder.isExpired(token!))
            ? HomePage(token: token!)
            : const FrontPage(),
      ),
    );
  }
}
