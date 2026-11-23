import 'package:material_ui/material_ui.dart';

class SettingsNetwork extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingsNetwork> createState() => _SettingsNetworkState();
}

class _SettingsNetworkState extends State<SettingsNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network"),
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