import 'package:material_ui/material_ui.dart';

class SettingsPrivacy extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsPrivacy> createState() => _SettingsPrivacyState();
}

class _SettingsPrivacyState extends State<SettingsPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
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