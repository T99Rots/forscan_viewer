import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

import 'graph.dart';
import 'legend.dart';

class CombinedGraph {
  CombinedGraph({
    required Range timeRange,
    required List<Data> data,
    required Offset mousePosition,
  })  : _timeRange = timeRange,
        _data = data,
        _mousePosition = mousePosition,
        _legend = Legend(
          timeRange: timeRange,
          valueRange: null,
        ) {
    // TODO: Create graphs.
  }

  final Legend _legend;
  final Map<Data, Graph> _graphs = <Data, Graph>{};

  // region Values

  Range _timeRange;
  Range get timeRange => _timeRange;
  set timeRange(Range value) {
    _legend.timeRange = value;
    _timeRange = value;
  }

  List<Data> _data;
  List<Data> get data => _data;
  set data(List<Data> value) {
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
    _legend.paint(canvas, outerRect);
  }
}
