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
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Text("Welcome $name!",
                style: TextStyle(fontSize: 40),),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('These are your tasks for today:')
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(value: false, onChanged: null),
                Text("Do this"),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(
                  Icons.edit,
                  size: 35,
                )),
                IconButton(onPressed: () {}, icon: Icon(
                    Icons.delete,
                    size: 35
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
