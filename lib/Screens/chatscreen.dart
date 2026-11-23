import 'package:material_ui/material_ui.dart';
import 'package:firefly/Model/ChatModel.dart';

class Chatscreen extends StatefulWidget {
  final ChatModel chatModel;

  const Chatscreen({super.key, required this.chatModel});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override

  final TextEditingController messageController = TextEditingController();

  void sendMessage(){
    String message = messageController.text;
    if (message.isEmpty) {
      return;
    }
    setState(() {

        });

    messageController.clear();
  }

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
        title: Column(
          children: [
            const Text(
              "widget.chatModel.isactive",
              style: TextStyle(
                fontSize: 14,
                fontWeight: .bold,
                color: Colors.red,
              ),
              // Jakby trzeba bylo na zielony ze aktywny to zielony, zmien jeszcze zeby tylko strzalka byla
            ),
            Text(widget.chatModel.name ?? "Chat"),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.phone), onPressed: () {})],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    // jesli chcesz powiekszyc maxlength to musisz zwiekszyc max lines
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(controller: messageController, minLines: 1, maxLines: 10 , maxLength: 256, decoration: InputDecoration(hintText: "Wpisz wiadomość..."),),
                    ),
                  ),
                  IconButton(onPressed: sendMessage, icon: Icon(Icons.send_rounded))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}