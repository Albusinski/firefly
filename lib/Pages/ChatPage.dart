import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:firefly/CustomUI/CustomCard.dart';
import 'package:firefly/Model/ChatModel.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Screens/newchatscreen.dart';
import 'package:firefly/data/providers.dart';
import 'package:firefly/Model/models.dart';

String _hhmm(int ms) {
  if (ms == 0) return '';
  final t = DateTime.fromMillisecondsSinceEpoch(ms);
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

ChatModel _toModel(ChatListItem c) => ChatModel(
  name: c.title,
  isGroup: c.isGroup,
  currentMessage: c.preview,
  time: _hhmm(c.lastActivity),
);

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  void _openChat(BuildContext context, ChatListItem c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Chatscreen(convId: c.id, chatModel: _toModel(c)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewChatScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text("New Chat"),
      ),
      body: chats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('Brak czatów'))
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => InkWell(
            onTap: () => _openChat(context, list[i]),
            child: CustomCard(chatModel: _toModel(list[i])),
          ),
        ),
      ),
    );
  }
}