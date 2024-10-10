import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/locate_blood_banks/locate_blood_banks_cubit.dart';
import 'package:donorconnect/cubit/profile/profile_cubit.dart';
import 'package:donorconnect/firebase_options.dart';
import 'package:donorconnect/services/blood_bank_service.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:donorconnect/views/pages/welcome/welcome_screen.dart';
import 'package:donorconnect/views/pages/verification/verification_form.dart'; // Import verification form
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
        BlocProvider(
          create: (context) => LocateBloodBanksCubit(BloodBankService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Main route selection
        home: (token != null && !JwtDecoder.isExpired(token!))
            ? HomePage(token: token!)
            : const FrontPage(),
        // You can add routes for the verification form
        routes: {
          '/verification': (context) => VerificationForm(), // Add route for verification form
        },
      ),
    );
  }
}
