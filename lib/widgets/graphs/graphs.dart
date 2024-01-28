import 'package:flutter/material.dart' hide Image;
import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

enum GraphRenderMode {
  separate,
  combined,
}

class Graphs extends LeafRenderObjectWidget {
  const Graphs({
    super.key,
    required this.mousePosition,
    required this.dataList,
    required this.timeRange,
    required this.mode,
  });

  final Offset mousePosition;
  final List<Data> dataList;
  final Range timeRange;
  final GraphRenderMode mode;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GraphsRenderer(
      mousePosition: mousePosition,
      dataList: dataList,
      timeRange: timeRange,
      mode: mode,
    );
  }
}

class GraphsRenderer extends RenderBox {
  GraphsRenderer({
    required Offset mousePosition,
    required List<Data> dataList,
    required Range timeRange,
    required GraphRenderMode mode,
  })  : _mousePosition = mousePosition,
        _dataList = dataList,
        _timeRange = timeRange,
        _mode = mode;

  // region Properties

  Offset _mousePosition;
  List<Data> _dataList;
  Range _timeRange;
  GraphRenderMode _mode;

  Offset get mousePosition => _mousePosition;
  set mousePosition(Offset value) {
    if (_mousePosition != value) {
      _mousePosition = value;
      markNeedsLayout();
    }
  }

  List<Data> get dataList => _dataList;
  set dataList(List<Data> value) {
    if (_dataList != value) {
      _dataList = value;
      markNeedsLayout();
    }
  }

  Range get timeRange => _timeRange;
  set timeRange(Range value) {
    if (_timeRange != value) {
      _timeRange = value;
      markNeedsLayout();
    }
  }

  GraphRenderMode get mode => _mode;
  set mode(GraphRenderMode value) {
    if (_mode != value) {
      _mode = value;
      markNeedsLayout();
    }
  }

  // endregion
}

class GraphOverlay {}
