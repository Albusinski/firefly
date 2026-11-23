import 'package:material_ui/material_ui.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child:
      // Row(children: [Icon(icon), Text(title)]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Padding(padding: const EdgeInsets.only(top: 2), child: Text(subtitle)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
