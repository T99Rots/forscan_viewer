import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

import 'graph.dart';
import 'legend.dart';

class SeparateGraph {
  SeparateGraph({
    required Range timeRange,
    required Data data,
    required Offset mousePosition,
  })  : _timeRange = timeRange,
        _data = data,
        _mousePosition = mousePosition,
        _graph = Graph(
          timeRange: timeRange,
          data: data,
        ),
        _legend = Legend(
          timeRange: timeRange,
          valueRange: data.range,
        );

  final Legend _legend;
  final Graph _graph;

  // region Values

  Range _timeRange;
  Range get timeRange => _timeRange;
  set timeRange(Range value) {
    _legend.timeRange = value;
    _graph.timeRange = value;
    _timeRange = value;
  }

  Data _data;
  Data get data => _data;
  set data(Data value) {
    _legend.valueRange = value.range;
    _graph.data = value;
    _data = value;
  }

  Offset _mousePosition;
  Offset get mousePosition => _mousePosition;
  set mousePosition(Offset value) {
    _mousePosition = value;
  }

  // endregion

  EdgeInsets layout() => _legend.layout();

  void paint(Canvas canvas, Rect outerRect, Rect graphRect) {
    _graph.paint(canvas, graphRect);
    _legend.paint(canvas, outerRect);
  }
}
