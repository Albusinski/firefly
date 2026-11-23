import 'package:firefly/CustomUI/SettingsProfile.dart';
import 'package:material_ui/material_ui.dart';
import 'package:firefly/Pages/SettingsAppearance.dart';
import 'package:firefly/Pages/SettingsNetwork.dart';
import 'package:firefly/Pages/SettingsNotifications.dart';
import 'package:firefly/Pages/SettingsPrivacy.dart';
import 'package:firefly/Pages/SettingsStorage.dart';
import 'package:firefly/CustomUI/SettingsTile.dart';

class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsProfile(),
        // Zostawilem to na dole bo bede pamietac jak sie textfieldy robi
        // Tutaj jest textfield na username ale chyba tego tak nie uzyje
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: TextField(
        //     maxLength: 32,
        //     textCapitalization: TextCapitalization.words,
        //     decoration: InputDecoration(hintText: "Podaj Nickname"),
        //   ),
        // ),
        SettingsTile(
          icon: Icons.palette,
          title: "Appearance",
          subtitle: "Theme, text size, chat background",
          page: SettingsAppearance(),
        ),
        SettingsTile(
          title: "Privacy",
          subtitle: "Receipts, visibility, blocked contacts",
          icon: Icons.lock,
          page: SettingsPrivacy(),
        ),
        SettingsTile(
          title: "Notifications",
          subtitle: "Banners and haptics",
          icon: Icons.notifications,
          page: Settingsnotifications(),
        ),
        SettingsTile(
          title: "Storage",
          subtitle: "Manage cached media and cleanup",
          icon: Icons.storage,
          page: SettingsStorage(),
        ),
        SettingsTile(
          title: "Network",
          subtitle: "Wi-Fi Direct connections and controls",
          icon: Icons.network_cell,
          page: SettingsNetwork(),
        ),

        // never - czerwony
        Center(
          child: Text(
            "Your Messages NEVER touch a server!!! ",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Center(
          child: Text(
            "Firefly 1.0 | WiFi Direct | ECDH P-256 + AES-256-GCM",
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}


