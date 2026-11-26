import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firefly/data/db/database.dart';
import 'package:firefly/Model/models.dart';

/// Jedna baza dla całej aplikacji
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Lista czatów. StreamProvider = sam się odświeża, gdy baza się zmieni
final chatsProvider = StreamProvider<List<ChatListItem>>(
      (ref) => ref.watch(dbProvider).watchChats(),
);

final contactsProvider = StreamProvider<List<ContactRow>>(
      (ref) => ref.watch(dbProvider).watchContacts(),
);

/// .family = pudełko z parametrem (tu: id rozmowy)
final messagesProvider = StreamProvider.family<List<MessageRow>, String>(
      (ref, convId) => ref.watch(dbProvider).watchMessages(convId),
);