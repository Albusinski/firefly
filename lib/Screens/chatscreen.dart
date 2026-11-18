import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const new({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 85,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, size: 20),
              CircleAvatar(radius: 20),
            ],
          ),
        ),
        title: const Text("this.name"),
      ),
    );
  }
}
