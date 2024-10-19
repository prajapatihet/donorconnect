import 'package:donorconnect/Utils/show_snackbar.dart';
import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/auth/auth_state.dart';

import 'package:donorconnect/language/helper/language_extention.dart';

import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Textbox.dart';
import '../../../cubit/forgot_password/forgot_password_cubit.dart';
import '../forgot_password/forgot-password.dart';
import '../register/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//variable to control password visibility
  bool _isPasswordVisible = false;
  // VALIDATION
  bool _isValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      context
          .read<AuthCubit>()
          .loginUser(emailController.text, passwordController.text);
    } else {
      showSnackBar(
        context,
        context.localizedString.please_enter_your_email_and_password,
      );
      setState(() {
        _isValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    const style = TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.w600);

    const style1 = TextStyle(
        color: Color.fromARGB(255, 18, 79, 43),
        fontSize: 20,
        fontWeight: FontWeight.w400);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomePage(
                  email: emailController.text,
                  name: state.user.name,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(
                    milliseconds: 900), // Adjust duration as needed
              ),
            );
          }
          if (state is AuthError) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              // BACKGROUND IMAGE
              Image.asset(
                'assets/images/login.jpg',
                width: double.infinity,
                height: 670,
                fit: BoxFit.cover,
              ),

              // WELCOME TEXT
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.34,
                      left: screenHeight * 0.03,
                      right: screenHeight * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_text.welcome_back, style: style),
                      Text(_text.log_in_to_your_account, style: style1),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),

                      // Name
                      Column(
                        children: [
                          Textbox(
                            controller: emailController,
                            obscureText: false,
                            icons: Icons.email,
                            name: _text.email,
                            errormsg: _isValidate
                                ? _text.email_field_error_text
                                : null,
                          ),

                          // PASSWORD
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Textbox(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            icons: Icons.lock,
                            name: _text.password,
                            errormsg:
                                _isValidate ? _text.password_error_text : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // FORGOT PASSWORD BUTTON
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.45),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ForgotPasswordCubit(
                                      FirebaseAuth.instance),
                                  child: ForgotPasswordScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            _text.forget_password,
                            style: TextStyle(
                                color: Color(0xff092414),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      // LOGIN BUTTON
                      SizedBox(
                        height: screenHeight * 0.12,
                      ),
                      GestureDetector(
                        onTap: loginUser,
                        child: Center(
                          child: Container(
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Center(
                              child: Text(
                                _text.login,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      //Google Login
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Image.asset('assets/images/google.png'),
                          iconSize: 50,
                          onPressed: () {
                            context.read<AuthCubit>().signInWithGoogle();
                          },
                        ),
                      ),
                      // FINAL TEXT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _text.do_not_have_account,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),

                          // SIGNUP BUTTON
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signuppage(),
                                  ));
                            },
                            child: Text(
                              _text.signup,
                              style: TextStyle(
                                  color: Color(0xff092414),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
