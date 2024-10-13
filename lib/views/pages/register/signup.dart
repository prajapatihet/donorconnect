import 'package:donorconnect/Utils/show_snackbar.dart';
import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/auth/auth_state.dart';
import 'package:donorconnect/views/pages/main_home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Utils/Textbox.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  // CONTROLLERS
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool? check1 = false, check2 = false;

  bool _isEmailValid = false;
  bool _isNameValid = false;
  bool _isPhoneValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool isPhoneValid() {
    return numberController.text.isNotEmpty &&
        (numberController.text.length == 10);
  }

  bool validatePassword(String password) {
    // Regular expression to validate the password
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);

    if (password.isEmpty) {
      return false; // Password cannot be empty
    } else if (!regex.hasMatch(password)) {
      return false; // Password doesn't match the pattern
    } else {
      return true; // Password is valid
    }
  }

  validate() {
    _isEmailValid =
        isValidEmail(emailController.text) && emailController.text.isNotEmpty;
    _isNameValid = nameController.text.isNotEmpty;
    _isPhoneValid = isPhoneValid();
    _isPasswordValid = validatePassword(passwordController.text);
    _isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty;
    if (_isEmailValid &&
        _isNameValid &&
        _isPhoneValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid) {
      if (passwordController.text == confirmPasswordController.text) {
        setState(() {
          _isPasswordValid = false;
          _isConfirmPasswordValid = false; // Reset validation flag
        });
        context.read<AuthCubit>().registerUser(
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
              phone: numberController.text,
              isOrganDonor: check1 ?? false,
              isBloodDonor: check2 ?? false,
            );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Center(
                    child: Text(
                  "Passwords don't match",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
              );
            });
        _isConfirmPasswordValid = true;
      }
    } else {
      setState(() {
        if (isValidEmail(emailController.text) == false) {
          _isEmailValid = true;
        } else {
          _isEmailValid = false;
        }
        //  _isEmailValid = true;
        if (nameController.text.isNotEmpty == false) {
          _isNameValid = true;
        } else {
          _isNameValid = false;
        }

        if (isPhoneValid() == false) {
          _isPhoneValid = true;
        } else {
          _isPhoneValid = false;
        }

        if (validatePassword(passwordController.text) == false) {
          _isPasswordValid = true;
        } else {
          _isPasswordValid = false;
          _isConfirmPasswordValid = false;
        }

        if (passwordController.text != confirmPasswordController.text) {
          _isConfirmPasswordValid = true;
        } else {
          _isConfirmPasswordValid = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // CONSTANTS
    const style = TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.w600);

    const style1 = TextStyle(
        color: Color.fromARGB(255, 18, 79, 43),
        fontSize: 18,
        fontWeight: FontWeight.w500);
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showSnackBar(context, state.message);
          }
          if (state is Authenticated) {
             Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomePage(
                  name: nameController.text,
                  email: emailController.text.trim(),
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 900), // Adjust duration as needed
              ),
            );
          
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
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              // FORM CONTAINER
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      left: screenHeight * 0.03,
                      right: screenHeight * 0.03),
                  child: Column(
                    children: [
                      // BACK BUTTON TO NAVIGATE BACK TO FRONT PAGE
                      Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const Text(
                        'Register',
                        style: style,
                      ),
                      const Text(
                        'Create your new account',
                        style: style1,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // EMAIL TEXTBOX
                      Textbox(
                        controller: emailController,
                        obscureText: false,
                        icons: Icons.mail,
                        name: 'Email',
                        errormsg: _isEmailValid
                            ? 'Email is Wrong or Blank, Kindly Enter correct Email'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // FULL NAME TEXTBOX
                      Textbox(
                        controller: nameController,
                        obscureText: false,
                        icons: Icons.person,
                        name: 'Full name',
                        errormsg: _isNameValid ? 'Name can not be Empty' : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // PHONE NUMBER TEXTBOX
                      Textbox(
                        controller: numberController,
                        obscureText: false,
                        icons: Icons.call,
                        name: 'Phone number',
                        errormsg: _isPhoneValid
                            ? 'Phone number must be of 10 Digit'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // PASSWORD TEXTBOX
                      Textbox(
                        controller: passwordController,
                        obscureText: true,
                        icons: Icons.lock,
                        name: 'Create password',
                        errormsg: _isPasswordValid
                            ? 'Password must be 8 character long and must have aleast 1 uppercase,1 Lowercase,1 digit,1 special character'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // CONFIRM PASSWORD
                      Textbox(
                        controller: confirmPasswordController,
                        obscureText: true,
                        icons: Icons.lock,
                        name: 'Confirm password',
                        errormsg: _isConfirmPasswordValid
                            ? 'Password is not matching'
                            : null,
                      ),

                      Row(
                        children: [
                          Checkbox(
                            //checkbox positioned at left
                            value: check1,
                            onChanged: (bool? value) {
                              setState(() {
                                check1 = value;
                              });
                            },
                          ),
                          const Text("Available for Organ Donation"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            //checkbox positioned at left
                            value: check2,
                            onChanged: (bool? value) {
                              setState(() {
                                check2 = value;
                              });
                            },
                          ),
                          const Text("Available for Blood Donation"),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      InkWell(
                        onTap: validate,
                        child: Center(
                          child: Container(
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.85,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 12, 48, 26),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: const Center(
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // FINAL TEXT
                      Text(
                        'By signing you agree to terms and \n      use and the privacy notice',
                        style: TextStyle(
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
