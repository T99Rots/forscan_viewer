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
    final String fullName = '${item.fullName} (${item.name})';

    return ColoredBox(
      color: item.color,
      child: RepaintBoundary(
        child: ListTile(
          leading: Checkbox(
            onChanged: (_) {
              onToggled();
            },
            value: selected,
            checkColor: Colors.black,
          ),
          onTap: onToggled,
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
