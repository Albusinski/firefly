import 'package:material_ui/material_ui.dart';
import 'package:firefly/Model/ChatModel.dart';

/// Tymczasowy model wiadomości (później możesz przenieść do Model/)
class _Message {
  final String text;
  final bool isMe;
  final DateTime time;

  _Message({required this.text, required this.isMe, DateTime? time})
      : time = time ?? DateTime.now();
}

class Chatscreen extends StatefulWidget {
  final String convId;
  final ChatModel chatModel;
  const Chatscreen({super.key, required this.convId, required this.chatModel});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController messageController = TextEditingController();

  // Najnowsza wiadomość na indeksie 0 (lista jest odwrócona: reverse: true)
  final List<_Message> _messages = [];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.insert(0, _Message(text: message, isMe: true));
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 85,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(widget.chatModel.name ?? "Chat"),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.phone), onPressed: () {})],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ---- LISTA WIADOMOŚCI ----
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text("Brak wiadomości"))
                  : ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, i) =>
                    _MessageBubble(message: _messages[i]),
              ),
            ),

            // ---- POLE WPISYWANIA ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 10,
                      maxLength: 256,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: "Wpisz wiadomość...",
                        counterText: '', // ukrywa licznik 0/256
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pojedynczy dymek czatu
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _Message message;

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMe = message.isMe;

    final bg = isMe ? scheme.primary : scheme.surfaceContainerHighest;
    final fg = isMe ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text, style: TextStyle(color: fg, fontSize: 16)),
            const SizedBox(height: 2),
            Text(
              _time(message.time),
              style: TextStyle(color: fg.withValues(alpha: 0.7), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}