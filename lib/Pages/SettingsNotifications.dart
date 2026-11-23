import 'package:material_ui/material_ui.dart';

class Settingsnotifications extends StatefulWidget {
  const new({super.key});

  @override
  State<Settingsnotifications> createState() => _SettingsnotificationsState();
}

class _SettingsnotificationsState extends State<Settingsnotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        leading: InkWell(onTap: () {
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(child: Column(
        // spacing: 80,
        children: [
        ],
      )),
    );
  }
}