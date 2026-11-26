import 'package:material_ui/material_ui.dart';

/// Tymczasowy model wyciszonego czatu (do podmiany na prawdziwy)
class _MutedChat {
  final String id;
  final String title;
  const _MutedChat(this.id, this.title);
}

class Settingsnotifications extends StatefulWidget {
  const Settingsnotifications({super.key});

  @override
  State<Settingsnotifications> createState() => _SettingsnotificationsState();
}

class _SettingsnotificationsState extends State<Settingsnotifications> {
  // --- USTAWIENIA (na razie tylko lokalnie) ---
  bool _banners = true;
  bool _haptics = true;

  // --- DANE TESTOWE ---
  final List<_MutedChat> _muted = [
    const _MutedChat("1", "Grupa niggowców"),
    const _MutedChat("2", "Aurelian Kowalnikow"),
  ];

  void _unmute(_MutedChat x) {
    setState(() => _muted.remove(x));
    // tu później: msgr.setMuted(x.id, false)
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // --- PRZEŁĄCZNIKI ---
            SwitchListTile(
              secondary: const Icon(Icons.vertical_align_top_rounded),
              title: const Text("In-app banners"),
              subtitle: const Text("Show a banner for messages in other chats"),
              value: _banners,
              onChanged: (v) => setState(() => _banners = v),
              // tu później: zapis ustawienia 'banners'
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration_rounded),
              title: const Text("Haptics"),
              subtitle: const Text("Vibrate for incoming messages and calls"),
              value: _haptics,
              onChanged: (v) => setState(() => _haptics = v),
              // tu później: zapis ustawienia 'haptics'
            ),

            // --- WYCISZONE CZATY ---
            const _SectionHeader("MUTED CHATS"),
            if (_muted.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No muted chats",
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              )
            else
              for (final x in _muted)
                ListTile(
                  leading: const Icon(Icons.notifications_off_rounded),
                  title: Text(x.title),
                  trailing: OutlinedButton(
                    onPressed: () => _unmute(x),
                    child: const Text("Unmute"),
                  ),
                ),

            // --- NOTKA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                "Firefly talks directly to nearby devices, so messages arrive while the app is open and connected.",
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
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