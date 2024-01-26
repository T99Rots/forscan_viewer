import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/utils/_utils.dart';
import 'package:forscan_viewer/utils/extensions/double_extension.dart';

class GraphLegend extends SingleChildRenderObjectWidget {
  const GraphLegend({
    super.key,
    super.child,
    required this.valueIntervalData,
    required this.timeIntervalData,
  });

  final IntervalData? valueIntervalData;
  final IntervalData? timeIntervalData;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GraphLegendRenderer(
      valueIntervalData: valueIntervalData,
      timeIntervalData: timeIntervalData,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant GraphLegendRenderer renderObject) {
    renderObject.valueIntervalData = valueIntervalData;
    renderObject.timeIntervalData = timeIntervalData;
  }
}

class GraphLegendRenderer extends RenderProxyBoxWithOffsetChild {
  GraphLegendRenderer({
    required IntervalData? valueIntervalData,
    required IntervalData? timeIntervalData,
  })  : _timeIntervalData = timeIntervalData,
        _valueIntervalData = valueIntervalData;

  IntervalData? _valueIntervalData;
  IntervalData? _timeIntervalData;

  double _graphTopPadding = 0;
  double _graphLeftPadding = 0;
  double _graphBottomPadding = 0;

  final List<TextPainter> _timeLegendPainters = <TextPainter>[];
  final List<TextPainter> _valueLegendPainters = <TextPainter>[];

  // Getters
  IntervalData? get valueIntervalData => _valueIntervalData;
  IntervalData? get timeIntervalData => _timeIntervalData;

  // Setters
  set valueIntervalData(IntervalData? valueIntervalData) {
    if (_valueIntervalData != valueIntervalData) {
      _valueIntervalData = valueIntervalData;
      markNeedsLayout();
    }
  }

  set timeIntervalData(IntervalData? timeIntervalData) {
    if (_timeIntervalData != timeIntervalData) {
      _timeIntervalData = timeIntervalData;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    _graphTopPadding = 0;
    _graphLeftPadding = 0;
    _graphBottomPadding = 0;

    final IntervalData? valueIntervalData = _valueIntervalData;
    final IntervalData? timeIntervalData = _timeIntervalData;

    if (valueIntervalData != null) {
      _valueLegendPainters.clear();

      for (int i = 0; i < valueIntervalData.intervals; i++) {
        final double numValue = valueIntervalData.range.start + (i * valueIntervalData.intervalSize);
        final String stringValue = numValue.toStringAsFixed(valueIntervalData.intervalSize.precision);

        final TextPainter painter = _createTextPainter(stringValue)..layout();

        if (painter.width > _graphLeftPadding) {
          _graphLeftPadding = painter.width;
        }

        _valueLegendPainters.add(painter);
      }

      _graphTopPadding = _valueLegendPainters.last.height / 2;
      _graphBottomPadding = _valueLegendPainters.first.height / 2;
    }

    if (timeIntervalData != null) {
      _timeLegendPainters.clear();

      for (int i = 0; i < timeIntervalData.intervals; i++) {
        final double numValue = timeIntervalData.range.start + (i * timeIntervalData.intervalSize);
        final Duration duration = Duration(milliseconds: numValue.toInt());

        final String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
        final String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        String durationString = '$minutes:$seconds';

        if (timeIntervalData.intervalSize.precision > 0) {
          durationString += '.${(duration.inMilliseconds.remainder(1000) / 100).floor().toString().padLeft(1, '0')}';
        }

        final TextPainter painter = _createTextPainter(durationString)..layout();

        if (painter.height > _graphBottomPadding) {
          _graphBottomPadding = painter.height;
        }

        _timeLegendPainters.add(painter);
      }
    }

    child?.layout(
      BoxConstraints.tight(
        Size(
          constraints.maxWidth - _graphLeftPadding,
          constraints.maxHeight - _graphBottomPadding - _graphTopPadding,
        ),
      ),
      parentUsesSize: false,
    );

    childParentData?.offset = Offset(
      _graphLeftPadding,
      _graphTopPadding,
    );

    size = constraints.biggest;
  }

  TextPainter _createTextPainter(String value) {
    final TextSpan span = TextSpan(
      text: value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    return TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  static final Paint _linePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final RenderBox? child = this.child;

    if (child == null) {
      return;
    }

    final Path path = Path();
    path.moveTo(_graphLeftPadding, _graphTopPadding);
    path.moveTo(_graphLeftPadding, size.height - _graphBottomPadding);
    path.moveTo(size.width, size.height - _graphBottomPadding);

    context.canvas.drawPath(path.shift(offset), _linePaint);

    final double stepSize = child.size.height / (_valueLegendPainters.length - 1);

    for (int i = 0; i < _valueLegendPainters.length; i++) {
      final TextPainter painter = _valueLegendPainters[_valueLegendPainters.length - i - 1];

      painter.paint(
        context.canvas,
        Offset(
          0,
          ((i + 1) * stepSize),
        ),
      );
    }
  }
}
