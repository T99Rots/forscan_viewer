import 'package:flutter/material.dart';
import 'package:forscan_viewer/parser/_parser.dart';

class SensorsListItem extends StatelessWidget {
  const SensorsListItem({
    super.key,
    required this.item,
    required this.onToggled,
    required this.selected,
  });

  final Data item;
  final VoidCallback onToggled;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    String fullName = item.fullName;

    if (item.unit != null) {
      fullName += ' (${item.unit})';
    }

    return ColoredBox(
      color: item.color,
      child: RepaintBoundary(
        child: CheckboxListTile(
          value: selected,
          onChanged: (_) {
            onToggled();
          },
          checkColor: Colors.black,
          title: Text(
            fullName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
