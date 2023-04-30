import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_luana_v1/pages/custom_level_map.dart';

import 'new_info_page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int? level;

  // sign user out method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  // get user level method
  Future<void> getUserLevel() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          level = snapshot.data()?['level'];
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'level': 0}).then((_) {
          setState(() {
            level = 0;
          });
        });
      }
    });
  }

  @override
  void initState() {
    getUserLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (snapshot.hasData &&
            (data?['level'] == null || data?['level'] == 0)) {
          return NewInfoPage();
        } else {
          // return Scaffold(
          //   appBar: AppBar(
          //     actions: [
          //       IconButton(
          //           onPressed: signUserOut, icon: const Icon(Icons.logout))
          //     ],
          //   ),
          //   body: Center(
          //     child: Text(
          //       "Logged in as: ${user.email!}\nLevel: ${data?['level']}",
          //       style: TextStyle(fontSize: 20),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // );
          return CustomLevelMapPage();
        }
      },
    );
  }
}
