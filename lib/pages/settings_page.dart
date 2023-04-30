import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(193, 181, 138, 1),
        title: Text('Settings'),
      ),
      backgroundColor: Color.fromRGBO(241, 226, 173, 1),
      body: Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24, color: Colors.grey[700]),
        ),
      ),
    );
  }
}