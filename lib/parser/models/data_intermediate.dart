import 'dart:ui';

import 'package:forscan_viewer/models/range.dart';

import '_models.dart';
import 'name_map.dart';

class DataIntermediate {
  DataIntermediate({
    required this.name,
    required this.color,
    required this.index,
  });

  final String name;
  final Color color;
  final int index;
  final List<DataPoint> points = <DataPoint>[];
  final List<String> enums = <String>[];
  double minimum = double.infinity;
  double maximum = double.negativeInfinity;
  bool containsEnums = false;

  void addPoint(int milliseconds, String value) {
    double? doubleValue = double.tryParse(value);

    if (doubleValue == null) {
      int index = enums.indexOf(value);
      if (index == -1) {
        enums.add(value);
        index = enums.length - 1;
      }

      doubleValue = index.toDouble();
      points.add(
        EnumDataPoint(
          milliseconds: milliseconds,
          value: doubleValue,
          valueString: value,
        ),
      );
    } else {
      points.add(
        DataPoint(
          milliseconds: milliseconds,
          value: doubleValue,
        ),
      );
    }

    if (doubleValue > maximum) {
      maximum = doubleValue;
    } else if (doubleValue < minimum) {
      minimum = doubleValue;
    }
  }

  static final RegExp nameRegex = RegExp(r'^([^(]+)(\(([^)]+)\))?$');

  Data toData() {
    points.sort((DataPoint a, DataPoint b) => a.milliseconds.compareTo(b.milliseconds));

    final List<DataPoint> sparsePoints = <DataPoint>[];

    for (int i = 1; i < points.length - 1; i++) {
      final DataPoint previous = points[i - 1];
      final DataPoint point = points[i];
      final DataPoint next = points[i + 1];
      if (previous.value != point.value || next.value != point.value) {
        sparsePoints.add(point);
      }
    }

    final RegExpMatch match = nameRegex.firstMatch(name)!;

    return Data(
      index: index,
      range: Range(minimum, maximum),
      points: points,
      name: match.group(1)!,
      fullName: nameMap[match.group(1)!] ?? name,
      unit: match.group(3),
      duration: points.last.milliseconds,
      color: color,
    );
  }
}
