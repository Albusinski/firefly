import 'package:material_ui/material_ui.dart';

class SettingsProfile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              //   Tutaj funkcja zmieniania profilowego
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(radius: 45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                //   funkcja edycji nickname
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 5,
                  children: [
                    Column(
                      children: [
                        const Text("Nickname", style: TextStyle(fontSize: 34)),
                        const Text("ID-U2nIkal-N3Id", style: TextStyle(fontSize: 14, color: Colors.yellow)),
                      ],
                    ),
                    Icon(Icons.edit)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}