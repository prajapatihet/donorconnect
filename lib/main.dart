import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/locate_blood_banks/locate_blood_banks_cubit.dart';
import 'package:donorconnect/cubit/profile/profile_cubit.dart';
import 'package:donorconnect/cubit/theme_toggle/theme_cubit.dart';
import 'package:donorconnect/cubit/theme_toggle/theme_state.dart';
import 'package:donorconnect/firebase_options.dart';
import 'package:donorconnect/language/cubit/language_cubit.dart';
import 'package:donorconnect/language/helper/language.dart';
import 'package:donorconnect/language/services/language_repositoty.dart';
import 'package:donorconnect/services/blood_bank_service.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:donorconnect/views/pages/onboarding/onboarding.dart';
import 'package:donorconnect/views/pages/welcome/welcome_screen.dart';
import 'package:donorconnect/views/verificationform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:riverpod/riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LanguageRepository.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  // await dotenv.load(fileName: '.env');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
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
        BlocProvider(
          create: (context) => LanguageCubit()..initilize(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..setInitialTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, Themestate>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, Language>(
              builder: (context, languageState) {
            return GetMaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(languageState.languageCode),
              //theme
              // themeMode: themeState.themeData,
              theme: themeState.themeData,
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              // Main route selection
              home:  (token != null && !JwtDecoder.isExpired(token!))
                  ? HomePage(token: token!)
                  : const OnBoardingScreen(),
              // You can add routes for the verification form
              routes: {
                '/verification': (context) =>
                    const VerificationForm(), // Add route for verification form
              },

            );
          });
        },
      ),
    );
  }
}