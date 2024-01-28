import 'dart:ui';

import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/models/data.dart';

class Overlay {
  Overlay({
    required this.timeRange,
    required this.data,
    required this.mousePosition,
  });

  Range timeRange;
  Data data;
  Offset mousePosition;

  void paint(Canvas canvas, Rect graphRect) {}
}
