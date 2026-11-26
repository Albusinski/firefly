import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:firefly/Model/models.dart';

part 'database.g.dart';

@DataClassName('ContactRow')
class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get bio => text().withDefault(const Constant(''))();
  TextColumn get publicKey => text().withDefault(const Constant(''))();
  BlobColumn get avatar => blob().nullable()();
  BoolColumn get verified => boolean().withDefault(const Constant(false))();
  BoolColumn get blocked => boolean().withDefault(const Constant(false))();
  IntColumn get lastSeen => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ConversationRow')
class Conversations extends Table {
  /// Contact id for direct chats, group id for groups.
  TextColumn get id => text()();
  BoolColumn get isGroup => boolean().withDefault(const Constant(false))();
  TextColumn get title => text().withDefault(const Constant(''))();
  IntColumn get unread => integer().withDefault(const Constant(0))();
  BoolColumn get muted => boolean().withDefault(const Constant(false))();
  IntColumn get lastActivity => integer().withDefault(const Constant(0))();
  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MemberRow')
class GroupMembers extends Table {
  TextColumn get groupId => text()();
  TextColumn get memberId => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  BoolColumn get isAdmin => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {groupId, memberId};
}

@DataClassName('MessageRow')
@TableIndex(name: 'idx_messages_conv', columns: {#conversationId, #createdAt})
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get body => text().withDefault(const Constant(''))();
  IntColumn get kind => integer().withDefault(const Constant(0))();
  TextColumn get fileName => text().nullable()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  TextColumn get mime => text().nullable()();
  IntColumn get width => integer().withDefault(const Constant(0))();
  IntColumn get height => integer().withDefault(const Constant(0))();

  /// Cached copy inside the app. Null once expired. Auto-deleted after 30 days.
  TextColumn get localPath => text().nullable()();

  /// Copy the user saved to Downloads/Firefly. Never auto-deleted.
  TextColumn get exportedUri => text().nullable()();
  IntColumn get cacheState => integer().withDefault(const Constant(0))();
  IntColumn get status => integer().withDefault(const Constant(0))();
  BoolColumn get outgoing => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PrefRow')
class Prefs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [Contacts, Conversations, GroupMembers, Messages, Prefs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'firefly'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  int get _now => DateTime.now().millisecondsSinceEpoch;

  // ───────────────────────── prefs
  Stream<Map<String, String>> watchPrefs() =>
      select(prefs).watch().map((rows) => {for (final r in rows) r.key: r.value});

  Future<String?> getPref(String k) async =>
      (await (select(prefs)..where((t) => t.key.equals(k))).getSingleOrNull())?.value;

  Future<void> setPref(String k, String v) =>
      into(prefs).insertOnConflictUpdate(PrefsCompanion(key: Value(k), value: Value(v)));

  // ───────────────────────── contacts
  Stream<List<ContactRow>> watchContacts() =>
      (select(contacts)..orderBy([(t) => OrderingTerm.asc(t.username)])).watch();

  Stream<ContactRow?> watchContact(String id) =>
      (select(contacts)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<ContactRow?> getContact(String id) =>
      (select(contacts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertContactIfAbsent(String id, String name) => into(contacts).insert(
    ContactsCompanion(id: Value(id), username: Value(name)),
    mode: InsertMode.insertOrIgnore,
  );

  Future<void> upsertContact({
    required String id,
    String? username,
    String? bio,
    String? publicKey,
    Uint8List? avatar,
    bool clearAvatar = false,
    int? lastSeen,
  }) async {
    await insertContactIfAbsent(id, username ?? '');
    await (update(contacts)..where((t) => t.id.equals(id))).write(ContactsCompanion(
      username: Value.absentIfNull(username),
      bio: Value.absentIfNull(bio),
      publicKey: Value.absentIfNull(publicKey),
      avatar: clearAvatar ? const Value(null) : (avatar == null ? const Value.absent() : Value(avatar)),
      lastSeen: Value.absentIfNull(lastSeen),
    ));
  }

  Future<void> setBlocked(String id, bool v) =>
      (update(contacts)..where((t) => t.id.equals(id))).write(ContactsCompanion(blocked: Value(v)));

  Future<void> setVerified(String id, bool v) =>
      (update(contacts)..where((t) => t.id.equals(id))).write(ContactsCompanion(verified: Value(v)));

  // ───────────────────────── conversations
  Future<ConversationRow?> getConversation(String id) =>
      (select(conversations)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<ConversationRow?> watchConversation(String id) =>
      (select(conversations)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<void> ensureConversation(String id, {bool isGroup = false, String title = ''}) =>
      into(conversations).insert(
        ConversationsCompanion(id: Value(id), isGroup: Value(isGroup), title: Value(title), lastActivity: Value(_now)),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> touchConversation(String id, {int unreadInc = 0, int? ms}) => customUpdate(
    'UPDATE conversations SET unread = unread + ?, last_activity = ? WHERE id = ?',
    variables: [Variable.withInt(unreadInc), Variable.withInt(ms ?? _now), Variable.withString(id)],
    updates: {conversations},
  );

  Future<void> setMuted(String id, bool v) =>
      (update(conversations)..where((t) => t.id.equals(id))).write(ConversationsCompanion(muted: Value(v)));

  Future<List<String>> groupIdsOf(String memberId) async {
    final rows = await customSelect(
      'SELECT group_id FROM group_members WHERE member_id = ?',
      variables: [Variable.withString(memberId)],
      readsFrom: {groupMembers},
    ).get();
    return rows.map((r) => r.read<String>('group_id')).toList();
  }

  Future<void> setGroupMeta(String id, {String? title, int? rev}) =>
      (update(conversations)..where((t) => t.id.equals(id)))
          .write(ConversationsCompanion(title: Value.absentIfNull(title), rev: Value.absentIfNull(rev)));

  Stream<List<ChatListItem>> watchChats() {
    const sql = '''
SELECT c.id AS id, c.is_group AS is_group, c.title AS title, c.unread AS unread, c.muted AS muted,
       c.last_activity AS last_activity,
       ct.username AS username, ct.avatar AS avatar, ct.blocked AS blocked,
       m.body AS body, m.kind AS kind, m.status AS status, m.outgoing AS outgoing, m.file_name AS file_name,
       sc.username AS sender_name
FROM conversations c
LEFT JOIN contacts ct ON ct.id = c.id
LEFT JOIN messages m ON m.id = (SELECT id FROM messages WHERE conversation_id = c.id ORDER BY created_at DESC LIMIT 1)
LEFT JOIN contacts sc ON sc.id = m.sender_id
ORDER BY c.last_activity DESC
''';
    return customSelect(sql, readsFrom: {conversations, contacts, messages}).watch().map((rows) {
      return rows.map((r) {
        final isGroup = r.read<int>('is_group') == 1;
        final username = r.readNullable<String>('username');
        final kindIdx = r.readNullable<int>('kind');
        final statusIdx = r.readNullable<int>('status');
        final title = isGroup ? r.read<String>('title') : ((username == null || username.isEmpty) ? 'Unknown' : username);
        return ChatListItem(
          id: r.read<String>('id'),
          isGroup: isGroup,
          title: title,
          avatar: r.readNullable<Uint8List>('avatar'),
          unread: r.read<int>('unread'),
          muted: r.read<int>('muted') == 1,
          lastActivity: r.read<int>('last_activity'),
          blocked: (r.readNullable<int>('blocked') ?? 0) == 1,
          lastBody: r.readNullable<String>('body') ?? '',
          lastKind: kindIdx == null ? null : enumAt(MsgKind.values, kindIdx),
          lastStatus: statusIdx == null ? null : enumAt(MsgStatus.values, statusIdx),
          lastOutgoing: (r.readNullable<int>('outgoing') ?? 0) == 1,
          lastFileName: r.readNullable<String>('file_name'),
          lastSender: r.readNullable<String>('sender_name'),
        );
      }).toList();
    });
  }

  Future<void> deleteConversation(String id) => transaction(() async {
    await (delete(messages)..where((t) => t.conversationId.equals(id))).go();
    await (delete(groupMembers)..where((t) => t.groupId.equals(id))).go();
    await (delete(conversations)..where((t) => t.id.equals(id))).go();
  });

  // ───────────────────────── members
  Stream<List<MemberRow>> watchMembers(String gid) => (select(groupMembers)
    ..where((t) => t.groupId.equals(gid))
    ..orderBy([(t) => OrderingTerm.desc(t.isAdmin), (t) => OrderingTerm.asc(t.name)]))
      .watch();

  Future<List<MemberRow>> getMembers(String gid) =>
      (select(groupMembers)..where((t) => t.groupId.equals(gid))).get();

  Future<Set<String>> memberIds(String gid) async => (await getMembers(gid)).map((m) => m.memberId).toSet();

  Future<Set<String>> adminIds(String gid) async =>
      (await getMembers(gid)).where((m) => m.isAdmin).map((m) => m.memberId).toSet();

  Future<void> replaceMembers(String gid, List<MemberInfo> list) => transaction(() async {
    await (delete(groupMembers)..where((t) => t.groupId.equals(gid))).go();
    for (final m in list) {
      await into(groupMembers).insertOnConflictUpdate(
        GroupMembersCompanion(groupId: Value(gid), memberId: Value(m.id), name: Value(m.name), isAdmin: Value(m.isAdmin)),
      );
    }
  });

  // ───────────────────────── messages
  Future<void> insertMessage(MessagesCompanion c) => into(messages).insert(c, mode: InsertMode.insertOrIgnore);

  Future<MessageRow?> getMessage(String id) =>
      (select(messages)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<bool> messageExists(String id) async => (await getMessage(id)) != null;

  Stream<List<MessageRow>> watchMessages(String conv) => (select(messages)
    ..where((t) => t.conversationId.equals(conv))
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ..limit(600))
      .watch();

  Future<void> setStatus(String id, MsgStatus s) =>
      (update(messages)..where((t) => t.id.equals(id))).write(MessagesCompanion(status: Value(s.index)));

  /// Monotonic progress: sent -> delivered -> read. Never lowers a status or touches failed.
  Future<void> raiseStatus(List<String> ids, MsgStatus s) async {
    if (ids.isEmpty) return;
    await (update(messages)
      ..where((t) => t.id.isIn(ids) & t.outgoing.equals(true) & t.status.isSmallerThanValue(s.index)))
        .write(MessagesCompanion(status: Value(s.index)));
  }

  /// Apply a failure/queued outcome only if the message hasn't already left the device.
  Future<void> setStatusIfPending(String id, MsgStatus s) async {
    await (update(messages)..where((t) => t.id.equals(id) & t.status.isSmallerThanValue(MsgStatus.sent.index)))
        .write(MessagesCompanion(status: Value(s.index)));
  }

  Future<void> requeueInFlight(String peerId) => customUpdate(
    'UPDATE messages SET status = 0 WHERE outgoing = 1 AND status = 1 AND conversation_id = ?',
    variables: [Variable.withString(peerId)],
    updates: {messages},
  );

  Future<void> setCacheState(String id, CacheState s, {String? localPath}) =>
      (update(messages)..where((t) => t.id.equals(id))).write(
        MessagesCompanion(cacheState: Value(s.index), localPath: localPath == null ? const Value.absent() : Value(localPath)),
      );

  Future<void> setExported(String id, String uri) =>
      (update(messages)..where((t) => t.id.equals(id))).write(MessagesCompanion(exportedUri: Value(uri)));

  Future<List<MessageRow>> queuedDirect(String peerId) => (select(messages)
    ..where((t) => t.conversationId.equals(peerId) & t.outgoing.equals(true) & t.status.isIn([0, 1]))
    ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();

  /// Marks unread incoming messages as read. Returns their ids.
  Future<List<String>> markIncomingRead(String conv) async {
    final unread = await (select(messages)
      ..where((t) => t.conversationId.equals(conv) & t.outgoing.equals(false) & t.status.equals(MsgStatus.delivered.index)))
        .get();
    if (unread.isNotEmpty) {
      await (update(messages)
        ..where((t) => t.conversationId.equals(conv) & t.outgoing.equals(false) & t.status.equals(MsgStatus.delivered.index)))
          .write(MessagesCompanion(status: Value(MsgStatus.read.index)));
    }
    await (update(conversations)..where((t) => t.id.equals(conv))).write(const ConversationsCompanion(unread: Value(0)));
    return unread.map((m) => m.id).toList();
  }

  Future<void> deleteMessage(String id) => (delete(messages)..where((t) => t.id.equals(id))).go();

  Future<void> deleteMessagesOf(String conv) => transaction(() async {
    await (delete(messages)..where((t) => t.conversationId.equals(conv))).go();
    await (update(conversations)..where((t) => t.id.equals(conv))).write(const ConversationsCompanion(unread: Value(0)));
  });

  Stream<List<MessageRow>> watchMedia(String conv) => (select(messages)
    ..where((t) => t.conversationId.equals(conv) & t.kind.isIn([MsgKind.image.index, MsgKind.video.index]) & t.cacheState.equals(CacheState.ready.index))
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Stream<List<MessageRow>> watchFiles(String conv) => (select(messages)
    ..where((t) => t.conversationId.equals(conv) & t.kind.equals(MsgKind.file.index) & t.cacheState.isIn([CacheState.ready.index, CacheState.expired.index]))
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Future<List<MessageRow>> filesOf(String conv) =>
      (select(messages)..where((t) => t.conversationId.equals(conv) & t.localPath.isNotNull())).get();

  // ───────────────────────── storage
  Future<List<MessageRow>> cachedRows() =>
      (select(messages)..where((t) => t.localPath.isNotNull() & t.cacheState.equals(CacheState.ready.index))).get();

  Future<List<MessageRow>> cachedBefore(int cutoffMs) => (select(messages)
    ..where((t) => t.localPath.isNotNull() & t.cacheState.equals(CacheState.ready.index) & t.createdAt.isSmallerThanValue(cutoffMs)))
      .get();

  Future<void> markExpired(String id) => (update(messages)..where((t) => t.id.equals(id))).write(
    MessagesCompanion(cacheState: Value(CacheState.expired.index), localPath: const Value(null)),
  );

  Future<int> expiredCount() async =>
      (await (select(messages)..where((t) => t.cacheState.equals(CacheState.expired.index))).get()).length;

  Future<int> exportedCount() async =>
      (await (select(messages)..where((t) => t.exportedUri.isNotNull())).get()).length;
}
