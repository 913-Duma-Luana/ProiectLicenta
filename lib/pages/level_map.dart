import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_luana_v1/pages/settings_page.dart';

import 'learning-material.dart';

class CustomLevelMapPage extends StatefulWidget {
  @override
  _CustomLevelMapPageState createState() => _CustomLevelMapPageState();
}

class _CustomLevelMapPageState extends State<CustomLevelMapPage> {
  int userLevel = 1;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _getUserLevel();
  }

  Future<void> _getUserLevel() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      userLevel = snapshot.data()!['level'] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(241, 226, 173, 1),
        appBar: AppBar(
          title: Text('Level Map',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold
              )
          ),
          backgroundColor: Color.fromRGBO(193, 181, 138, 1),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.grey[800],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: userLevel != null
            ? LevelMap(
          backgroundColor: const Color.fromRGBO(241, 226, 173, 1),
          levelMapParams: LevelMapParams(
            levelCount: 4,
            currentLevel: userLevel.toDouble(),
            pathColor: Colors.grey.shade700,
            currentLevelImage: ImageParams(
              path: "lib/images/map-images/current_black.png",
              size: Size(40, 47),
            ),
            lockedLevelImage: ImageParams(
              path: "lib/images/map-images/locked_black.png",
              size: Size(40, 42),
            ),
            completedLevelImage: ImageParams(
              path: "lib/images/map-images/completed_black.png",
              size: Size(40, 42),
            ),
            startLevelImage: ImageParams(
              path: "lib/images/map-images/WalrusHeadColored.png",
              size: Size(60, 60),
            ),
            pathEndImage: ImageParams(
              path: "lib/images/map-images/WalrusAngryColored.png",
              size: Size(60, 60),
            ),
            // Customize these images according to your project's theme and requirements
            bgImagesToBePaintedRandomly: [
              ImageParams(
                  path: "lib/images/map-images/MachineBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
              ImageParams(
                  path: "lib/images/map-images/MorseTextBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
              ImageParams(
                  path: "lib/images/map-images/MorseHiTextBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
              ImageParams(
                  path: "lib/images/map-images/MorseProfessorBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
              ImageParams(
                  path: "lib/images/map-images/WalrusHeadBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
              ImageParams(
                  path: "lib/images/map-images/WalrusRoundHeadBlack.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.15),
            ],
          ),
        )
            : CircularProgressIndicator(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(193, 181, 138, 1),
          child: Icon(
            Icons.list,
            color: Colors.grey[800],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LearningMaterialPage()),
            );
          },
        ),
      ),
    );
  }
}
