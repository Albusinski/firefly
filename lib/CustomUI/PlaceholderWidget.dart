import 'package:material_ui/material_ui.dart';

class Placeholderwidget extends StatelessWidget {
  const new({super.key, required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: Color.fromRGBO(1, 1, 1, 0.23),
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: child,
    );
  }
}