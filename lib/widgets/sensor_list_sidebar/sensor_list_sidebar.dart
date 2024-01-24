import 'package:flutter/material.dart';
import 'package:forscan_viewer/parser/models/_models.dart';
import 'package:forscan_viewer/widgets/sensor_list_sidebar/sensors_list_item.dart';

class SensorListSidebar extends StatelessWidget {
  const SensorListSidebar({
    super.key,
    required this.data,
    required this.dataToggled,
    required this.selected,
  });

  final List<Data> data;
  final ValueChanged<Data> dataToggled;
  final Set<Data> selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ListView(
        children: List<Widget>.generate(
          data.length,
          (int index) => SensorsListItem(
            item: data[index],
            onToggled: () => dataToggled(data[index]),
            selected: selected.contains(data[index]),
          ),
        ),
      ),
    );
  }
}
