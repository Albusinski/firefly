// lib/data/messenger.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firefly/data/db/database.dart';
import 'package:firefly/data/providers.dart';
import 'package:firefly/Model/models.dart';

abstract class Messenger {
  Future<void> send(String peerId, String text);
// później: startDiscovery, connectTo, disconnect, incoming...
}

class FakeMessenger implements Messenger {
  FakeMessenger(this.db);
  final AppDatabase db;

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Future<void> send(String peerId, String text) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // upewnij się, że kontakt i rozmowa istnieją
    await db.insertContactIfAbsent(peerId, peerId);
    await db.ensureConversation(peerId);

    await db.insertMessage(MessagesCompanion.insert(
      id: _id(),
      conversationId: peerId,
      senderId: 'me',
      createdAt: now,
      body: Value(text),
      outgoing: const Value(true),
      status: Value(MsgStatus.sent.index),
    ));
    await db.touchConversation(peerId);

    // symulacja odpowiedzi drugiej osoby po 1 sekundzie
    Future.delayed(const Duration(seconds: 1), () async {
      await db.insertMessage(MessagesCompanion.insert(
        id: _id(),
        conversationId: peerId,
        senderId: peerId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        body: Value('Echo: $text'),
        status: Value(MsgStatus.delivered.index),
      ));
      await db.touchConversation(peerId, unreadInc: 1);
    });
  }
}

final messengerProvider = Provider<Messenger>(
      (ref) => FakeMessenger(ref.watch(dbProvider)),
);