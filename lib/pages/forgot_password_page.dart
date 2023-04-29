import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/login_button.dart';
import '../components/login_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //text editing controller
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // password reset function
  Future resetPasswordForEmail() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim()
      );
      displayMessage(
          'Reset password email sent successfully!',
          'The email containing a reset password link has been successfully sent'
              ' to the email address you provided. Please check your inbox '
              'and follow the steps in there so you can recover your account.'
      );
    } on FirebaseAuthException catch(error){
      displayMessage(
        'There has been an error while trying to send the email',
        error.message.toString()
      );
    }
  }

  void displayMessage(
      String title,
      String content
      ){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(content),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child:
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text(
                  'Reset your password',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Enter your email address below and we will send you '
                        'a password reset link',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //email
                const SizedBox(height: 25),
                LoginTextField(
                  controller: emailController,
                  hintText: 'Enter your email address here',
                  obscureText: false,
                ),

                // send reset password email to that address
                const SizedBox(height: 25),
                LoginButton(
                  onTap: resetPasswordForEmail,
                  text: 'Send email',
                ),
            ]
            ),
          ),
        ),
      ),
    );
  }
}
