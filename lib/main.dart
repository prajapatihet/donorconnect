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
import 'package:donorconnect/views/pages/login/login.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:donorconnect/views/pages/onboarding/onboarding.dart';
import 'package:donorconnect/views/pages/welcome/welcome_screen.dart';
import 'package:donorconnect/views/verificationform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  await LanguageRepository.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: '.env');

  // Check if the user has completed onboarding and if they are logged in
  bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
  String? token = prefs.getString('token');
  bool isLoggedIn = token != null && !JwtDecoder.isExpired(token);

  // Lock orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize the app
  runApp(MyApp(
    token: isLoggedIn ? token : null,
    onboardingCompleted: onboardingCompleted,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  final bool onboardingCompleted;

  const MyApp({
    required this.token,
    required this.onboardingCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(
            create: (context) =>
                AuthCubit(FirebaseAuth.instance, FirebaseFirestore.instance)),
        BlocProvider(
            create: (context) => LocateBloodBanksCubit(BloodBankService())),
        BlocProvider(create: (context) => LanguageCubit()..initilize()),
        BlocProvider(create: (context) => ThemeCubit()..setInitialTheme()),
      ],
      child: BlocBuilder<ThemeCubit, Themestate>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, Language>(
            builder: (context, languageState) {
              return GetMaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: Locale(languageState.languageCode),
                theme: themeState.themeData,
                darkTheme: ThemeData.dark(),
                debugShowCheckedModeBanner: false,
                home: onboardingCompleted
                    ? (token != null
                        ? HomePage(
                            token:
                                token!) // Directly navigate to home page if logged in
                        : const LoginPage()) // Navigate to login if not logged in
                    : const OnBoardingScreen(), // Navigate to onboarding if not completed
                routes: {
                  '/verification': (context) => const VerificationForm(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
