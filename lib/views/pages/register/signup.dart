import 'package:flutter/material.dart';
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
  bool? check1 = false, check2 = false;
  bool _isValidate = false;

  validate() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        numberController.text.isNotEmpty) {
      setState(() {
        _isValidate = false; // Reset validation flag
      });
    } else {
      setState(() {
        _isValidate = true;
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
      body: Stack(
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
                  top: screenHeight * 0.09,
                  left: screenHeight * 0.03,
                  right: screenHeight * 0.03),
              child: Column(
                children: [
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
                    icons: Icons.mail,
                    name: 'Email',
                    errormsg: _isValidate ? 'Please enter Email' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // FULL NAME TEXTBOX
                  Textbox(
                    controller: nameController,
                    icons: Icons.person,
                    name: 'Full name',
                    errormsg: _isValidate ? 'Please enter Full name' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // PHONE NUMBER TEXTBOX
                  Textbox(
                    controller: numberController,
                    icons: Icons.call,
                    name: 'Phone number',
                    errormsg: _isValidate ? 'Please enter Phone number' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // PASSWORD TEXTBOX
                  Textbox(
                    controller: passwordController,
                    icons: Icons.lock,
                    name: 'Create password',
                    errormsg: _isValidate ? 'Please enter Password' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  Textbox(
                    controller: passwordController,
                    icons: Icons.lock,
                    name: 'Confirm password',
                    errormsg: _isValidate ? 'Please enter Password' : null,
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
                      Text("Available for Organ Donation"),
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
                      Text("Available for Blood Donation"),
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
      ),
    );
  }
}
