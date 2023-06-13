import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: OurosHome(),
  ));
}

class OurosHome extends StatefulWidget {
  const OurosHome({Key? key}) : super(key: key);

  @override
  State<OurosHome> createState() => _OurosHomeState();
}
const name = "XD";

class _OurosHomeState extends State<OurosHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ouroboros"
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,0,20),
                child: Text("Welcome $name"),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(value: false, onChanged: null),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,196,0),
                child: Text("Do this"),
              ),
              IconButton(onPressed: () {}, icon: Icon(
                Icons.delete
              )),
              IconButton(onPressed: () {}, icon: Icon(
                  Icons.edit
              ))
            ],
          )
        ],
      ),
    );
  }
}
