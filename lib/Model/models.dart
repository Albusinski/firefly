import 'dart:typed_data';

enum MsgKind { text, image, video, file, call }

/// Stored as int. Incoming messages use delivered (unread) and read.
enum MsgStatus { queued, sending, sent, delivered, read, failed }

enum CacheState { none, transferring, ready, expired, failed, cancelled }

enum LinkPhase { idle, connecting, negotiating, failed }

enum CallPhase { idle, outgoing, incoming, active }

T enumAt<T>(List<T> values, int i) => values[i < 0 ? 0 : (i >= values.length ? values.length - 1 : i)];

class ChatListItem {
  const ChatListItem({
    required this.id,
    required this.isGroup,
    required this.title,
    required this.avatar,
    required this.unread,
    required this.muted,
    required this.lastActivity,
    required this.blocked,
    this.lastBody = '',
    this.lastKind,
    this.lastStatus,
    this.lastOutgoing = false,
    this.lastFileName,
    this.lastSender,
  });

  final String id;
  final bool isGroup;
  final String title;
  final Uint8List? avatar;
  final int unread;
  final bool muted;
  final int lastActivity;
  final bool blocked;
  final String lastBody;
  final MsgKind? lastKind;
  final MsgStatus? lastStatus;
  final bool lastOutgoing;
  final String? lastFileName;
  final String? lastSender;

  String get preview {
    switch (lastKind) {
      case null:
        return 'No messages yet';
      case MsgKind.text:
        return lastBody;
      case MsgKind.image:
        return 'Photo';
      case MsgKind.video:
        return 'Video';
      case MsgKind.file:
        return lastFileName ?? 'File';
      case MsgKind.call:
        return lastBody;
    }
  }
}

class NearbyPeer {
  const NearbyPeer({required this.address, required this.name, required this.status, this.fireflyId, this.username});
  final String address;
  final String name;

  /// WifiP2pDevice status: 0 connected, 1 invited, 2 failed, 3 available, 4 unavailable.
  final int status;
  final String? fireflyId;
  final String? username;

  bool get isFirefly => fireflyId != null;
  String get displayName => (username != null && username!.isNotEmpty) ? username! : name;
}

class TransferProgress {
  const TransferProgress({required this.bytes, required this.total, required this.incoming});
  final int bytes;
  final int total;
  final bool incoming;
  double get fraction => total <= 0 ? 0 : (bytes / total).clamp(0.0, 1.0).toDouble();
}

class CallState {
  const CallState({this.phase = CallPhase.idle, this.peerId = '', this.callId = '', this.startedAtMs = 0, this.muted = false, this.speaker = false});
  final CallPhase phase;
  final String peerId;
  final String callId;
  final int startedAtMs;
  final bool muted;
  final bool speaker;

  CallState copyWith({CallPhase? phase, String? peerId, String? callId, int? startedAtMs, bool? muted, bool? speaker}) => CallState(
        phase: phase ?? this.phase,
        peerId: peerId ?? this.peerId,
        callId: callId ?? this.callId,
        startedAtMs: startedAtMs ?? this.startedAtMs,
        muted: muted ?? this.muted,
        speaker: speaker ?? this.speaker,
      );
}

/// Transient in-app banner (incoming message or system notice).
class AppNotice {
  const AppNotice({required this.seq, required this.title, required this.body, this.convId});
  final int seq;
  final String title;
  final String body;
  final String? convId;
}

class TransferUiState {
  const TransferUiState();
}

class StorageUsage {
  const StorageUsage({this.images = 0, this.videos = 0, this.files = 0, this.cachedCount = 0, this.expiredCount = 0, this.exportedCount = 0});
  final int images;
  final int videos;
  final int files;
  final int cachedCount;
  final int expiredCount;
  final int exportedCount;
  int get total => images + videos + files;
}

class PickedFile {
  const PickedFile({required this.path, required this.name, this.forceFile = false});
  final String path;
  final String name;
  final bool forceFile;
}

class MemberInfo {
  const MemberInfo({required this.id, required this.name, required this.isAdmin});
  final String id;
  final String name;
  final bool isAdmin;
}

class MessengerState {
  const MessengerState({
    this.ready = false,
    this.supported = true,
    this.myId = '',
    this.myKey = '',
    this.deviceName = '',
    this.wifiEnabled = true,
    this.discovering = false,
    this.nearby = const [],
    this.online = const {},
    this.phase = LinkPhase.idle,
    this.phaseMessage,
    this.connectingTo,
    this.justConnected,
    this.call = const CallState(),
    this.notice,
    this.error,
  });

  static const _unset = Object();

  final bool ready;
  final bool supported;
  final String myId;
  final String myKey;
  final String deviceName;
  final bool wifiEnabled;
  final bool discovering;
  final List<NearbyPeer> nearby;
  final Set<String> online;
  final LinkPhase phase;
  final String? phaseMessage;
  final String? connectingTo;
  final String? justConnected;
  final CallState call;
  final AppNotice? notice;
  final String? error;

  MessengerState copyWith({
    bool? ready,
    bool? supported,
    String? myId,
    String? myKey,
    String? deviceName,
    bool? wifiEnabled,
    bool? discovering,
    List<NearbyPeer>? nearby,
    Set<String>? online,
    LinkPhase? phase,
    Object? phaseMessage = _unset,
    Object? connectingTo = _unset,
    Object? justConnected = _unset,
    CallState? call,
    Object? notice = _unset,
    Object? error = _unset,
  }) {
    return MessengerState(
      ready: ready ?? this.ready,
      supported: supported ?? this.supported,
      myId: myId ?? this.myId,
      myKey: myKey ?? this.myKey,
      deviceName: deviceName ?? this.deviceName,
      wifiEnabled: wifiEnabled ?? this.wifiEnabled,
      discovering: discovering ?? this.discovering,
      nearby: nearby ?? this.nearby,
      online: online ?? this.online,
      phase: phase ?? this.phase,
      phaseMessage: identical(phaseMessage, _unset) ? this.phaseMessage : phaseMessage as String?,
      connectingTo: identical(connectingTo, _unset) ? this.connectingTo : connectingTo as String?,
      justConnected: identical(justConnected, _unset) ? this.justConnected : justConnected as String?,
      call: call ?? this.call,
      notice: identical(notice, _unset) ? this.notice : notice as AppNotice?,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
