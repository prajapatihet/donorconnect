

import 'package:donorconnect/views/pages/forgot_password/change-password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:donorconnect/cubit/forgot_password/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    const style1 = TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold);
    return Scaffold(
         // backgroundColor: const Color.fromARGB(255, 244, 208, 208),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset email sent!')),
                );
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is ForgotPasswordLoading) {
                return const Center(child: CircularProgressIndicator());
              }
        
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Set New Password',
                    style: style1,
                  ),
                  const SizedBox(height: 30),
                 //               // Email text form field
                 ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
    
        controller: emailController,
        decoration: const InputDecoration(
          label:Text('Email'),
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          focusedErrorBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.email,
            size: 20,
          ),
          prefixIconColor: Colors.black,
          
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: Color.fromARGB(153, 243, 233, 233),
          filled: true,
        ),
        validator: validateEmail,
      ),
    ),
           
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(90, 16, 90, 20),
                    ),
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.read<ForgotPasswordCubit>().resetPassword(email).then(
                          (value) =>  Navigator.push(
  context,
  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
)
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid email')),
                        );
                      }
                    },
                    child:   GestureDetector(
                         
                          child: Center(
                            child: Container(
                             
                              decoration: const BoxDecoration(
                               
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child:  Center(
                                child: Text(
                                  'Send Reset Email',
                                  style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                                
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
    String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E-Mail Address is required';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return 'Invalid E-Mail Address Format';
    }
    return null;
  }
}
