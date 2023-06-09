import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: OurosHome(),
  ));
}

class OurosHome extends StatelessWidget {
  const OurosHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
