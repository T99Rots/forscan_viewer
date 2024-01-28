import 'dart:ui';

import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/_parser.dart';

class Graph {
  Graph({
    required Range timeRange,
    required Data data,
  })  : _timeRange = timeRange,
        _data = data;

  bool _shouldPaint = true;
  Image? _cached;

  // region Values

  Range _timeRange;
  Range get timeRange => _timeRange;
  set timeRange(Range value) {
    if (value != _timeRange) {
      _shouldPaint = true;
      _cached?.dispose();

      _timeRange = value;
    }
  }

  Data _data;
  Data get data => _data;
  set data(Data value) {
    if (value != _data) {
      _shouldPaint = true;
      _cached?.dispose();

      _data = value;
    }
  }

  // endregion

  void paint(Canvas canvas, Rect graphRect) {
    final Image? cached = _cached;

    if (!_shouldPaint && cached != null && cached.height == graphRect.height && cached.width == graphRect.width) {
      canvas.drawImage(
        cached,
        graphRect.topLeft,
        Paint(),
      );

      return;
    }
  }
}
