import 'package:material_ui/material_ui.dart';

class SettingsAppearance extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsAppearance> createState() => _SettingsAppearanceState();
}

class _SettingsAppearanceState extends State<SettingsAppearance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
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