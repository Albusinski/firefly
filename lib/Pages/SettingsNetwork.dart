import 'package:material_ui/material_ui.dart';
import 'package:firefly/Services/SettingsService.dart';

/// Tymczasowy model aktywnego połączenia (do podmiany na prawdziwy)
class _Link {
  final String id;
  final String name;

  const _Link(this.id, this.name);
}

class SettingsNetwork extends StatefulWidget {
  const SettingsNetwork({super.key});

  @override
  State<SettingsNetwork> createState() => _SettingsNetworkState();
}

class _SettingsNetworkState extends State<SettingsNetwork> {
  // --- USTAWIENIA / STAN (na razie tylko lokalnie) ---
  bool _wifiEnabled = true; // później: m.wifiEnabled
  bool _autoReconnect = true;
  final String _deviceName = "Pixel 7"; // później: m.deviceName

  // --- DANE TESTOWE ---
  final List<_Link> _links = [
    const _Link("1", "Aurelian Kowal"),
    const _Link("2", "Marek"),
  ];

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _disconnect(_Link x) {
    setState(() => _links.remove(x));
    // tu później: msgr.disconnectPeer(x.id)
  }

  void _disconnectAll() {
    setState(() => _links.clear());
    // tu później: msgr.disconnectAll()
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const green = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // --- WI-FI ---
            ListTile(
              leading: const Icon(Icons.wifi_rounded),
              title: const Text("Wi-Fi"),
              subtitle: Text(
                _wifiEnabled
                    ? "Wi-Fi Direct is available"
                    : "Turn Wi-Fi on to connect to people nearby",
              ),
              trailing: Text(
                _wifiEnabled ? "On" : "Off",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _wifiEnabled ? green : scheme.error,
                ),
              ),
              // tu później: msgr.openWifiSettings() (na razie przełącza symulację)
              onTap: () => setState(() => _wifiEnabled = !_wifiEnabled),
            ),

            // --- TO URZĄDZENIE ---
            ListTile(
              leading: const Icon(Icons.smartphone_rounded),
              title: const Text("This device"),
              subtitle: Text(_deviceName.isEmpty ? "Unknown" : _deviceName),
            ),

            // --- UPRAWNIENIE ---
            ListTile(
              leading: const Icon(Icons.shield_rounded),
              title: const Text("Nearby devices permission"),
              subtitle: const Text("Required for discovery"),
              onTap: () {
                // tu później: hasP2pPermissions() / requestP2pPermissions() / openAppSettings()
                _toast("Permission granted");
              },
            ),

            // --- AUTO-RECONNECT ---
            SwitchListTile(
              secondary: const Icon(Icons.sync_rounded),
              title: const Text("Auto-reconnect"),
              subtitle: const Text("Retry when a connection drops"),
              value: settings.autoReconnect,
              onChanged: (v) {
                setState(() {
                  settings.set('autoReconnect', v);
                });
              },
              // tu później: zapis ustawienia 'autoReconnect'
            ),

            // --- POŁĄCZONE TERAZ ---
            const _SectionHeader("CONNECTED NOW"),
            if (_links.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No active connections",
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              )
            else
              for (final x in _links)
                ListTile(
                  leading: const Icon(Icons.link_rounded),
                  title: Text(x.name),
                  subtitle: const Text("Encrypted link"),
                  trailing: OutlinedButton(
                    onPressed: () => _disconnect(x),
                    child: const Text("Disconnect"),
                  ),
                ),

            // --- DISCONNECT ALL (tylko gdy jest więcej niż 1) ---
            if (_links.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: _disconnectAll,
                    icon: const Icon(Icons.link_off_rounded),
                    label: const Text("Disconnect all"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.error,
                      side: BorderSide(color: scheme.error),
                    ),
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
