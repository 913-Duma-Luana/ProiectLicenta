import 'package:flutter/material.dart';

class LearningMaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(193, 181, 138, 1),
        title: Text('Information List'),
      ),
      backgroundColor: Color.fromRGBO(241, 226, 173, 1),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              'Information Item ${index + 1}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          );
        },
      ),
    );
  }
}