import 'package:donorconnect/Utils/show_snackbar.dart';
import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/auth/auth_state.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Textbox.dart';
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
      context.read<AuthCubit>().loginUser(
            emailController.text,
            passwordController.text,
          );
    } else {
      showSnackBar(
        context,
        'Please enter your email and password',
      );
      setState(() {
        _isValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  email: emailController.text,
                  name: state.user.name,
                ),
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
                height: double.infinity,
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
                      const Text('Welcome Back', style: style),
                      const Text('Log in to your account', style: style1),
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
                            name: 'Email',
                            errormsg: _isValidate ? 'Please enter Email' : null,
                          ),

                          // PASSWORD
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Textbox(
                            controller: passwordController,
                            obscureText: true,
                            icons: Icons.lock,
                            name: 'Password',
                            errormsg:
                                _isValidate ? 'Please enter Password' : null,
                          ),
                        ],
                      ),

                      // FORGOT PASSWORD BUTTON
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.45),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Color(0xff092414),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      // LOGIN BUTTON
                      SizedBox(
                        height: screenHeight * 0.18,
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
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // FINAL TEXT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have the account?',
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
                            child: const Text(
                              'Sign up',
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
