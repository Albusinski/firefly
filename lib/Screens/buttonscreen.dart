import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class buttonscreen extends StatefulWidget {
  const new({super.key});

  @override
  State<buttonscreen> createState() => _buttonscreenState();
}

class _buttonscreenState extends State<buttonscreen> {

  List<Chatmodel> chats = [
    Chatmodel(
      name: "name1",
      isGroup: false,
      currentMessage: "message1",
      time: "time1",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("chat forwarder debug"))),
      body: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => Chatscreen())),
          );
        },
        child: Center(child: const Text("test", style: TextStyle(fontSize: 34)),),
      ),
    );
  }
}
