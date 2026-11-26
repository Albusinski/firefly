import 'package:material_ui/material_ui.dart';
import 'package:firefly/Services/SettingsService.dart';

// Tymczasowy model zablokowanego kontaktu (do podmiany na prawdziwy)
class _BlockedContact {
  final String id;
  final String name;

  const _BlockedContact(this.id, this.name);
}

class SettingsPrivacy extends StatefulWidget {
  const SettingsPrivacy({super.key});

  @override
  State<SettingsPrivacy> createState() => _SettingsPrivacyState();
}

class _SettingsPrivacyState extends State<SettingsPrivacy> {
  // --- DANE TESTOWE ---
  final List<_BlockedContact> _blocked = [
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-A1B2", "Marek"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
    const _BlockedContact("FF-C3D4", "Ola"),
  ];

  void _unblock(_BlockedContact x) {
    setState(() => _blocked.remove(x));
    // tu później: msgr.setBlocked(x.id, false)
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.done_all_rounded),
              title: const Text("Read receipts"),
              subtitle: const Text(
                "Let people see when you have read their messages",
              ),
              value: settings.readReceipts,
              onChanged: (v) {
                setState(() {
                  settings.set('readReceipts', v);
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.badge_rounded),
              title: const Text("Share bio and photo"),
              subtitle: const Text("Sent to peers when you connect"),
              value: settings.shareProfile,
              onChanged: (v) {
                setState(() {
                  settings.set('shareProfile', v);
                });
                // tu później: msgr.broadcastHello()
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.visibility_rounded),
              title: const Text("Visible to nearby devices"),
              subtitle: const Text("Advertise your name while discovery is on"),
              value: settings.discoverable,
              onChanged: (v) {
                setState(() {
                  settings.set('discoverable', v);
                });
                // tu później: msgr.refreshAdvertisement()
              },
            ),

            // --- ZABLOKOWANI ---
            const _SectionHeader("BLOCKED"),
            if (_blocked.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No blocked contacts",
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              )
            else
              for (final x in _blocked)
                ListTile(
                  leading: Icon(Icons.block_rounded, color: scheme.error),
                  title: Text(x.name, style: TextStyle(color: scheme.error)),
                  trailing: OutlinedButton(
                    onPressed: () => _unblock(x),
                    child: const Text("Unblock"),
                  ),
                ),

            // --- NOTKA O BEZPIECZEŃSTWIE ---
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            //   child: Text(
            //     "How Firefly protects you: each device holds a private key in the Android Keystore. "
            //     "Your FIREFLY ID is a hash of its public key, so it cannot be impersonated. "
            //     "Every link is mutually authenticated, then encrypted with AES-256-GCM using fresh "
            //     "ECDH keys, so past traffic stays safe even if a key leaks later.",
            //     style: TextStyle(
            //       fontSize: 12.5,
            //       height: 1.5,
            //       color: scheme.onSurfaceVariant,
            //     ),
            //   ),
            // ),
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
