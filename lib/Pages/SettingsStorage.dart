import 'package:material_ui/material_ui.dart';

// Tymczasowy model kategorii plików (do podmiany na prawdziwy)
class _Category {
  final String name;
  final IconData icon;
  int bytes;
  int count;
  _Category(this.name, this.icon, this.bytes, this.count);
}

class SettingsStorage extends StatefulWidget {
  const SettingsStorage({super.key});

  @override
  State<SettingsStorage> createState() => _SettingsStorageState();
}

class _SettingsStorageState extends State<SettingsStorage> {
  static const int _maxAgeDays = 30; // później: StorageService.maxAge.inDays

  // --- DANE TESTOWE ---
  final List<_Category> _cats = [
    _Category("Photos", Icons.photo_rounded, 120 * 1024 * 1024, 84),
    _Category("Videos", Icons.videocam_rounded, 340 * 1024 * 1024, 12),
    _Category("Files", Icons.insert_drive_file_rounded, 45 * 1024 * 1024, 9),
  ];

  // "stare" pliki, które usunie przycisk "Remove files older than..."
  int _oldCount = 7;
  int _oldBytes = 60 * 1024 * 1024;

  int get _totalBytes => _cats.fold(0, (a, c) => a + c.bytes);
  int get _totalCount => _cats.fold(0, (a, c) => a + c.count);

  String _fmt(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _purgeExpired() {
    // tu później: await storage.purgeExpired()
    if (_oldCount == 0) {
      _toast("Nothing to remove");
      return;
    }
    final n = _oldCount;
    setState(() {
      // symulacja: stare pliki znikają z filmów
      _cats[1].bytes = (_cats[1].bytes - _oldBytes).clamp(0, 1 << 40);
      _cats[1].count = (_cats[1].count - n).clamp(0, 1 << 20);
      _oldCount = 0;
      _oldBytes = 0;
    });
    _toast("Removed $n files");
  }

  Future<void> _clearCache() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear cached files?"),
        content: const Text(
          "Photos, videos and files from your chats are removed from this device. "
              "Messages stay, and files you saved to Downloads are not touched.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Clear"),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    // tu później: await storage.clearCache()
    final n = _totalCount;
    setState(() {
      for (final c in _cats) {
        c.bytes = 0;
        c.count = 0;
      }
      _oldCount = 0;
      _oldBytes = 0;
    });
    _toast("Cleared $n files");
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // --- KARTA Z ZAJĘTOŚCIĄ ---
            _UsageCard(
              total: _fmt(_totalBytes),
              totalCount: _totalCount,
              rows: [
                for (final c in _cats)
                  _UsageRow(
                    icon: c.icon,
                    name: c.name,
                    size: _fmt(c.bytes),
                    count: c.count,
                    fraction: _totalBytes == 0 ? 0 : c.bytes / _totalBytes,
                  ),
              ],
            ),

            // --- AKCJE ---
            ListTile(
              leading: const Icon(Icons.auto_delete_rounded),
              title: const Text("Remove files older than $_maxAgeDays days"),
              subtitle: const Text("Runs automatically. Messages stay."),
              onTap: _purgeExpired,
            ),
            ListTile(
              leading: Icon(Icons.delete_sweep_rounded, color: scheme.error),
              title: Text(
                "Clear cache now",
                style: TextStyle(color: scheme.error),
              ),
              subtitle: const Text("Deletes every cached file on this device"),
              onTap: _clearCache,
            ),

            // --- NOTKA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                "Received and sent files are temporary. They are deleted $_maxAgeDays days after arrival. "
                    "Anything you save with “Save to device” lives in Downloads/Firefly and is never removed by Firefly.",
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

class _UsageRow {
  final IconData icon;
  final String name;
  final String size;
  final int count;
  final double fraction;
  const _UsageRow({
    required this.icon,
    required this.name,
    required this.size,
    required this.count,
    required this.fraction,
  });
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({
    required this.total,
    required this.totalCount,
    required this.rows,
  });

  final String total;
  final int totalCount;
  final List<_UsageRow> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              total,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            Text(
              "$totalCount cached files",
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(r.icon, size: 20, color: scheme.primary),
                        const SizedBox(width: 10),
                        Expanded(child: Text(r.name)),
                        Text(
                          "${r.size} · ${r.count}",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: r.fraction,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}