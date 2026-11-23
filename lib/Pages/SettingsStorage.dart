import 'package:material_ui/material_ui.dart';

class SettingsStorage extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsStorage> createState() => _SettingsStorageState();
}

class _SettingsStorageState extends State<SettingsStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage"),
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