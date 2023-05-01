import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_luana_v1/components/cancel_button.dart';
import 'package:project_luana_v1/components/login_button.dart';
import 'package:project_luana_v1/components/login_square_tile.dart';

class QuizQuestionPage extends StatefulWidget {
  final int levelId;
  final int questionId;

  QuizQuestionPage({required this.levelId, required this.questionId});

  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late Future<Map<String, dynamic>?> _questionData;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _questionData = _fetchQuestionData(widget.levelId, widget.questionId);
  }

  TextStyle _questionTextStyle() {
    return TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]);
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[700]),
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      primary: Color.fromRGBO(193, 181, 138, 1),
      onPrimary: Colors.grey[800],
    );
  }

  void _incrementUserLevelAndReturnToMap(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final userData = await userRef.get();
    final currentLevel = userData['level'] as int;

    if (widget.levelId == currentLevel) {
      await userRef.update({'level': FieldValue.increment(1)});
    }

    Navigator.pop(context);
  }

  Future<Map<String, dynamic>?> _fetchQuestionData(
      int levelId, int questionId) async {
    final questionsSnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('level', isEqualTo: levelId)
        .where('id', isEqualTo: questionId)
        .get();
    if (questionsSnapshot.docs.isEmpty) {
      return null;
    }
    final questionDoc = questionsSnapshot.docs.first;
    final question = questionDoc.data() as Map<String, dynamic>;

    final answersSnapshot = await FirebaseFirestore.instance
        .collection('answers')
        .where('question id', isEqualTo: questionId)
        .get();
    final answers = answersSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return {
      'question': question,
      'answers': answers,
    };
  }

  Widget _buildQuizContent(Map<String, dynamic> questionData) {
    final question = questionData['question'];
    final answers = questionData['answers'];

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        SizedBox(height: 80),
        Center(
          child: Text(
            question['title'],
            style: _questionTextStyle(),
          ),
        ),
        SizedBox(height: 16),
        ...answers.map<Widget>((answer) {
          return ListTile(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(251, 246, 230, 1),
                  border: Border.all(color: Color.fromRGBO(217, 203, 156, 1)),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                answer['value'],
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            onTap: () {
              if (answer['correct']) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Correct! Well done!')));

                // If correct, navigate to the next question
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizQuestionPage(
                      levelId: widget.levelId,
                      questionId: widget.questionId + 1,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect! Try again.')));
              }
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWriteEnglishContent(Map<String, dynamic> questionData) {
    final question = questionData['question'];
    final answer = questionData['answers'][0]['value'];

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Decode the following sequence of Morse code symbols:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      question['title'],
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _answerController,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(217, 203, 156, 1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(193, 181, 138, 1)),
                      ),
                      fillColor: const Color.fromRGBO(251, 246, 230, 1),
                      filled: true,
                      labelText: 'Your answer',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(height: 16),
                  LoginButton(
                      text: 'Submit',
                      onTap: () {
                        if (_answerController.text.trim().toLowerCase() ==
                            answer) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Correct! Well done!')));

                          // If correct, navigate to the next question
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizQuestionPage(
                                levelId: widget.levelId,
                                questionId: widget.questionId + 1,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Incorrect! Try again.')));
                        }
                      }),
                  SizedBox(height: 100)
                ],
              )));
    });
  }

  Widget _buildWriteMorseContent(Map<String, dynamic> questionData) {
    final question = questionData['question'];
    final answer = questionData['answers'][0]['value'];

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Rewrite in Morse Code:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      question['title'],
                      style: _questionTextStyle(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _answerController,
                    readOnly: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(217, 203, 156, 1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(193, 181, 138, 1)),
                      ),
                      fillColor: const Color.fromRGBO(251, 246, 230, 1),
                      filled: true,
                      labelText: 'Your answer',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LoginSquareTile(
                          imagePath: 'lib/images/morse-symbols/dot.png',
                          onTap: () =>
                              setState(() => _answerController.text += '.')),
                      LoginSquareTile(
                          imagePath: 'lib/images/morse-symbols/dash.png',
                          onTap: () =>
                              setState(() => _answerController.text += '-')),
                      LoginSquareTile(
                          imagePath: 'lib/images/morse-symbols/space.png',
                          onTap: () =>
                              setState(() => _answerController.text += ' ')),
                      LoginSquareTile(
                          imagePath: 'lib/images/morse-symbols/slash.png',
                          onTap: () =>
                              setState(() => _answerController.text += '/')),
                    ],
                  ),
                  SizedBox(height: 16),
                  CancelButton(
                      text: 'Erase all',
                      onTap: () {
                        _answerController.text = "";
                      }),
                  SizedBox(height: 16),
                  LoginButton(
                      text: 'Submit',
                      onTap: () {
                        if (_answerController.text.trim() == answer) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Correct! Well done!')));

                          // If correct, navigate to the next question
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizQuestionPage(
                                levelId: widget.levelId,
                                questionId: widget.questionId + 1,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Incorrect! Try again.')));
                        }
                      }),
                  SizedBox(height: 80),
                ],
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(241, 226, 173, 1),
        appBar: AppBar(
          title: Text(
            'Level ${widget.levelId}: Question ${widget.questionId}',
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(193, 181, 138, 1),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _questionData,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _incrementUserLevelAndReturnToMap(context);
              });
              return Container();
            }

            final questionType = snapshot.data!['question']['type'];

            if (questionType == 'quiz') {
              return _buildQuizContent(snapshot.data!);
            } else if (questionType == 'write english') {
              return _buildWriteEnglishContent(snapshot.data!);
            } else if (questionType == 'write morse') {
              return _buildWriteMorseContent(snapshot.data!);
            } else {
              return Center(child: Text('Invalid question type'));
            }
          },
        ));
  }
}
