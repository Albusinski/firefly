import 'package:firefly/CustomUI/CustomCard.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Model/ChatModel.dart';
import 'package:material_ui/material_ui.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  void openChat(ChatModel chat) {
    print("Kliknięto czat: ${chat.name}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chatscreen(chatModel: chat)),
    );
  }

  List<ChatModel> chats = [
    ChatModel(
      name: "Aurelian Kowal",
      isGroup: false,
      currentMessage: "Nate Higgers",
      time: "12:30",
      //icon:"cos.png",
    ),
    ChatModel(
      name: "Aurelian Kowalnikow",
      isGroup: false,
      currentMessage: "Nate Higgers",
      time: "10:30",
      //icon:"cos.png",
    ),
    ChatModel(
      name: "Grupa niggowców",
      isGroup: true,
      currentMessage: "Nig nig nig saniggahur",
      time: "13:30",

      //icon:"cos.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // debugPrint("KLIKNIETO CZAT!");
              // debugPrint("Nazwa: ${chats[index].name}");
              // bylo potrzebne, bo bardzo glupia rzecz sie stala, w customcard byl tez inkwell i przycisk wgl nie reagowal NA NIC

              openChat(chats[index]);
            },
            child: CustomCard(
              chatModel: chats[index],
            ),
          );
        },
      ),
    );
  }
}
