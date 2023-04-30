import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_luana_v1/components/login_square_tile.dart';
import 'package:project_luana_v1/components/login_textfield.dart';

import '../components/login_button.dart';
import '../services/auth_service.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in
  void signUserIn() async{
    // show loading circle while the user waits for the operation to perform
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator(),);
    });

    // try the sign in operation
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Eliminate the loading progress circle
      Navigator.pop(context);

    } on FirebaseAuthException catch (error){
      // Eliminate the loading progress circle
      Navigator.pop(context);

      // Wrong email
      if (error.code == 'user-not-found'){
        displayErrorMessage(
            'Incorrect email',
            'The email address you provided is not associated to any account.\n'
            'Try another email address or register with a new account instead.');
      }

      // Wrong password
      else if (error.code == 'wrong-password'){
        displayErrorMessage(
            'Incorrect password',
            'The password you provided is not correct.\n'
            'If you can\'t remember it anymore, try "Forgot password" instead.'
        );
      }

      // Another error
      else {
        displayErrorMessage(
          'Internal authentication error',
          'There has been an error while trying to authenticate you.\n'
          'If the error persists, please try again later.'
        );
      }
    }
  }

  void displayErrorMessage(
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
      backgroundColor: const Color.fromRGBO(241, 226, 173, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              // Logo
              const SizedBox(height: 10),
              // const Icon(
              //   Icons.lock,
              //   size:100,
              // ),
              Container(
                width: 150,
                height: 150,
                child: Image.asset(
                  'lib/images/cute-walrus-cartoon-cropped-logo.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Welcome back message
              // const SizedBox(height: 25),
              Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                )
              ),

              //email
              const SizedBox(height: 25),
              LoginTextField(
                controller: emailController,
                hintText: 'Enter your email address here',
                obscureText: false,
              ),

              //password
              const SizedBox(height: 10),
              LoginTextField(
                controller: passwordController,
                hintText: 'Enter here the password to your account',
                obscureText: true,
              ),

              //forgot password
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context){
                            return ForgotPasswordPage();
                        }));
                      },
                      child: Text('Forgot password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                    ),
                  ],
                ),
              ),

              //signin
              const SizedBox(height: 25),
              LoginButton(
                onTap: signUserIn,
                text: 'Sign in',
              ),

              //or continue with
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),

                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                    ),
                  ],
                ),
              ),

              //google + apple signin
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  LoginSquareTile(
                      imagePath: 'lib/images/google-logo.png',
                      onTap: () => AuthService().signInWithGoogle()
                  ),
                  const SizedBox(width: 10,),
                  //apple button
                  LoginSquareTile(
                      imagePath: 'lib/images/apple-logo.png',
                      onTap: () => AuthService().signInWithGoogle()
                  ),
                ],
              ),

              // not a member -> register
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text('Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      ),
                     ),
                  ),
                ],)
            ]
            ),
          ),
        ),
      ),
    );
  }
}