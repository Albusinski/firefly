import 'package:firefly/Pages/SettingsAppearance.dart';
import 'package:material_ui/material_ui.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.title, required this.subtitle, required this.icon, required this.page});

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
          // Navigator.pushNamed(context, route); - to jest alternatywa gdzie sie odwoluje do routetow w mainie ale bardzo lagowala aplikacje
        },
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
      ),
    );
  }
}
