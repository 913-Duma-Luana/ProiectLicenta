import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizQuestionPage extends StatefulWidget {
  final int questionId;

  QuizQuestionPage({required this.questionId});

  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late Future<Map<String, dynamic>> _questionData;

  @override
  void initState() {
    super.initState();
    _questionData = _fetchQuestionData(widget.questionId);
  }

  Future<Map<String, dynamic>> _fetchQuestionData(int questionId) async {
    final questionRef =
    FirebaseFirestore.instance.collection('questions').doc('$questionId');
    final questionSnapshot = await questionRef.get();
    final question = questionSnapshot.data() as Map<String, dynamic>;

    final answersSnapshot = await FirebaseFirestore.instance
        .collection('answers')
        .where('question_id', isEqualTo: questionId)
        .get();
    final answers =
    answersSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return {
      'question': question,
      'answers': answers,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Question'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _questionData,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final question = snapshot.data!['question'];
          final answers = snapshot.data!['answers'];

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text(
                question['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ...answers.map<Widget>((answer) {
                return ListTile(
                  title: Text(answer['value']),
                  onTap: () {
                    final result = answer['correct']
                        ? 'Correct! Well done!'
                        : 'Incorrect! Try again.';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  },
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
