import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'splash.dart';

void main() {
  runApp(MaterialApp(
    home: splashscreen(),
  ));
}

class OurosHome extends StatefulWidget {
  const OurosHome({Key? key}) : super(key: key);

  @override
  State<OurosHome> createState() => _OurosHomeState();
}

class Task {
  String name;
  bool isCompleted;

  Task({
    required this.name,
    required this.isCompleted,
  });
}

Task myTask = Task(
  name: 'Finish this app',
  isCompleted: false,
);



class _OurosHomeState extends State<OurosHome> {
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
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Text("Welcome!",
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: myTask.isCompleted,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() {
                          myTask.isCompleted = newValue;
                        });
                      }
                    },
                  ),
                  Text(myTask.name),
                  Spacer(),
                  IconButton(onPressed: () {}, icon: Icon(
                    Icons.edit,
                    size: 25,
                  )),
                  IconButton(onPressed: () {}, icon: Icon(
                      Icons.delete,
                      size: 25
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
