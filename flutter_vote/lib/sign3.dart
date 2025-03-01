import 'package:flutter/material.dart';

class SignPage3 extends StatelessWidget {
  const SignPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bac_app1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 360,
                height: 60,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "We are verifying your details.After verifying you can accesss your account",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ))));
  }
}
