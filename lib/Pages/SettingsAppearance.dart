import 'package:firefly/CustomUI/PlaceholderWidget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:firefly/theme.dart';

class SettingsAppearance extends StatefulWidget {
  const SettingsAppearance({super.key});

  @override
  State<SettingsAppearance> createState() => _SettingsAppearanceState();
}

class _SettingsAppearanceState extends State<SettingsAppearance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          // spacing: 80,
          children: [Themepicker()],
        ),
      ),
    );
  }
}

class Themepicker extends StatefulWidget {
  const Themepicker({super.key});

  @override
  State<Themepicker> createState() => _ThemepickerState();
}

class _ThemepickerState extends State<Themepicker> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedTheme = ref.watch(themeNotifierProvider);

        return Column(
          spacing: 20,
          children: [
            SizedBox(height: 10),

            Placeholderwidget(
              height: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SegmentedButton<ThemeMode>(
                  selected: {selectedTheme},
                  segments: [
                    ButtonSegment(value: ThemeMode.light, label: Text("Light")),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text("System"),
                    ),
                    ButtonSegment(value: ThemeMode.dark, label: Text("Dark")),
                  ],
                  onSelectionChanged: (value) {
                    ref
                        .read(themeNotifierProvider.notifier)
                        .setTheme(value.first);
                  },
                ),
              ),
            ),

            Placeholderwidget(height: 120, child: Text("Zmina tekstu")),
            Placeholderwidget(height: 80, child: Text("Zmina rozmiaru tekstu")),
          ],
        );
      },
    );
  }
}
