import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Model/ChatModel.dart';
import 'package:material_ui/material_ui.dart';

class ButtonScreen extends StatefulWidget {
  final ChatModel chatModel;

  const ButtonScreen({super.key, required this.chatModel});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {

  List<ChatModel> chats = [
    ChatModel(
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
              MaterialPageRoute(
                builder: (context) => Chatscreen(chatModel: widget.chatModel),
              ),

          );
        },
        child: Center(child: const Text("test", style: TextStyle(fontSize: 34)),),
      ),
    );
  }
}
