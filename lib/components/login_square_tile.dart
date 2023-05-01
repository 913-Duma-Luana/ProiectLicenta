import 'package:flutter/material.dart';

class LoginSquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const LoginSquareTile(
      {Key? key, required this.imagePath, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(217, 203, 156, 1)),
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromRGBO(251, 246, 230, 1),
        ),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
