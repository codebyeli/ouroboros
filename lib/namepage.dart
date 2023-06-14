import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: namescreen(),
  ));
}

class namescreen extends StatefulWidget {
  const namescreen({Key? key}) : super(key: key);

  @override
  State<namescreen> createState() => _namescreenState();
}

class _namescreenState extends State<namescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/miniourosicon.png'),
        title: Text(
            "Ouroboros"
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(

      ),
    );
  }
}