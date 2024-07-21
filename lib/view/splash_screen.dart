import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Transform.scale(
            scale: 1.1,
            child: Lottie.asset("lib/assets/Animation - 1721215209651.json",
                fit: BoxFit.cover),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  "lib/assets/Design.png"),
              SizedBox(
                height: 50,
              ),
              Text(
                "UNSUNG MEMER",
                style: TextStyle(
                  fontFamily: "Lexend",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
