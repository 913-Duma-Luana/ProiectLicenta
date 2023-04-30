import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class NewInfoPage extends StatelessWidget {
  final bool isFirstTimeUser;

  NewInfoPage({Key? key, this.isFirstTimeUser = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(193, 181, 138, 1),
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(241, 226, 173, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Hello Morse Newbie!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This is an example of a cute-looking page in Flutter. You can customize the colors, fonts, and other elements as you like. The key to creating a cute design is to use soft colors, rounded shapes, and playful fonts. Remember to keep things simple and clean, and don\'t be afraid to experiment with different styles!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (isFirstTimeUser) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .update({'level': 1});
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(193, 181, 138, 1),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Go to Homepage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
