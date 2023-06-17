import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(MaterialApp(
    home: splashscreen(),
  ));
}

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  void _navigateToMain() async {
    await Future.delayed(Duration(milliseconds: 2500));
    Navigator.pushReplacement(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => OurosHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
          Image.asset('assets/miniourosicon.png'),
        color: Colors.black,
        alignment: Alignment.center,
      )
    );
  }
}

