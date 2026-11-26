import 'package:material_ui/material_ui.dart';
import 'package:firefly/Model/ChatModel.dart';
import 'package:firefly/Screens/chatscreen.dart';

/// Tymczasowy model osoby (do podmiany, gdy podepniesz P2P)
class _Person {
  final String name;
  final String subtitle;
  const _Person(this.name, this.subtitle);
}

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _radar;

  // --- DANE TESTOWE ---
  final List<_Person> _connected = const [
    _Person("Aurelian Kowal", "Connected · tap to chat"),
  ];
  final List<_Person> _nearby = const [
    _Person("Marek", "Firefly · FF-A1B2"),
    _Person("Ola", "Firefly · FF-C3D4"),
    _Person("Pixel 7", "Wi-Fi Direct device"),
  ];
  final List<_Person> _saved = const [
    _Person("Aurelian Kowalnikow", "Last seen yesterday"),
  ];

  _Person? _connecting; // osoba, z którą właśnie "się łączymy"

  @override
  void initState() {
    super.initState();
    _radar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _radar.dispose();
    super.dispose();
  }

  void _openChat(_Person p) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Chatscreen(
          chatModel: ChatModel(
            name: p.name,
            isGroup: false,
            currentMessage: "",
            time: "",
          ),
        ),
      ),
    );
  }

  /// Symulacja łączenia – później zastąpisz to prawdziwym P2P
  Future<void> _connectTo(_Person p) async {
    setState(() => _connecting = p);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted || _connecting != p) return; // anulowano
    _connecting = null;
    _openChat(p);
  }

  void _cancelConnect() => setState(() => _connecting = null);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New chat"),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {}, // tu później: restart wyszukiwania
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              bottom: bottom + (_connecting != null ? 150 : 40),
            ),
            children: [
              const SizedBox(height: 16),
              Center(child: _buildRadar(scheme)),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Looking for people nearby…",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 40, 20),
                child: Text(
                  "Ask them to open this screen too. Devices appear here as soon as they are in range.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
                ),
              ),

              // --- NEW GROUP ---
              ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: scheme.primary,
                  child: Icon(Icons.group_add_rounded, color: scheme.onPrimary),
                ),
                title: const Text("New group"),
                subtitle: const Text("Chat with several people at once"),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {}, // tu później: ekran tworzenia grupy
              ),

              if (_connected.isNotEmpty) ...[
                const _SectionHeader("CONNECTED"),
                for (final p in _connected)
                  _PersonTile(
                    person: p,
                    online: true,
                    trailing: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    onTap: () => _openChat(p),
                  ),
              ],

              if (_nearby.isNotEmpty) ...[
                const _SectionHeader("NEARBY"),
                for (final p in _nearby)
                  _PersonTile(
                    person: p,
                    online: false,
                    trailing: FilledButton(
                      onPressed: _connecting == null ? () => _connectTo(p) : null,
                      child: const Text("Connect"),
                    ),
                  ),
              ],

              if (_saved.isNotEmpty) ...[
                const _SectionHeader("SAVED CONTACTS"),
                for (final p in _saved)
                  _PersonTile(
                    person: p,
                    online: false,
                    trailing: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    onTap: () => _openChat(p),
                  ),
              ],
            ],
          ),

          // --- DOLNA KARTA "CONNECTING" ---
          if (_connecting != null)
            Positioned(
              left: 14,
              right: 14,
              bottom: 14 + bottom,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(strokeWidth: 2.6),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Connecting to ${_connecting!.name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "They will see an invitation to accept.",
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _cancelConnect,
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Animowany radar: 3 rozchodzące się fale + ikona na środku
  Widget _buildRadar(ColorScheme scheme) {
    const size = 220.0;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _radar,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < 3; i++) _wave((_radar.value + i / 3) % 1.0, size, scheme),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.25),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Icon(Icons.wifi_tethering_rounded, size: 36, color: scheme.primary),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _wave(double t, double maxSize, ColorScheme scheme) {
    final d = 84 + (maxSize - 84) * t;
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: scheme.primary.withValues(alpha: (1 - t) * 0.5),
          width: 2,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({
    required this.person,
    required this.online,
    required this.trailing,
    this.onTap,
  });

  final _Person person;
  final bool online;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Stack(
        children: [
          const CircleAvatar(radius: 26, child: Icon(Icons.person_rounded)),
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(person.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        person.subtitle,
        style: TextStyle(color: online ? Colors.green : scheme.onSurfaceVariant),
      ),
      trailing: trailing,
    );
  }
}