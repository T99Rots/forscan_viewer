import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/utils/extensions/double_extension.dart';

class Legend {
  Legend({
    required Range timeRange,
    required Range? valueRange,
  })  : _timeRange = timeRange,
        _valueRange = valueRange;

  EdgeInsets? _cachedLayoutResult;
  final List<TextPainter> _valuePainters = <TextPainter>[];
  IntervalData? _valueData;
  final List<TextPainter> _timePainters = <TextPainter>[];
  IntervalData? _timeData;
  bool _shouldLayout = true;

  // region Values

  Range _timeRange;
  Range get timeRange => _timeRange;
  set timeRange(Range value) {
    if (value != _timeRange) {
      _shouldLayout = true;
      _timeRange = value;
    }
  }

  Range? _valueRange;
  Range? get valueRange => _valueRange;
  set valueRange(Range? value) {
    if (value != _valueRange) {
      _shouldLayout = true;
      _valueRange = value;
    }
  }

  // endregion

  EdgeInsets layout() {
    final EdgeInsets? cachedLayoutResult = _cachedLayoutResult;
    if (cachedLayoutResult != null && !_shouldLayout) {
      return cachedLayoutResult;
    }

    final Range? valueRange = _valueRange;
    _shouldLayout = false;
    double leftPadding = 0;
    double topPadding = 0;
    double bottomPadding = 0;

    if (valueRange != null) {
      final IntervalData? valueData = IntervalData.compute(valueRange, 12);
      _valueData = valueData;

      if (valueData != null) {
        for (int i = 0; i < valueData.intervals; i++) {
          final double numValue = valueData.range.start + (i * valueData.intervalSize);
          final String stringValue = numValue.toStringAsFixed(valueData.intervalSize.precision);

          final TextPainter painter = _createTextPainter(stringValue)..layout();

          if (painter.width > leftPadding) {
            leftPadding = painter.width;
          }

          _valuePainters.add(painter);
        }

        topPadding = _valuePainters.last.height / 2;
        bottomPadding = _valuePainters.first.height / 2;
      }
    }

    final IntervalData? timeData = IntervalData.compute(timeRange, 20);
    _timeData = timeData;

    if (timeData != null) {
      for (int i = 0; i < timeData.intervals; i++) {
        final double numValue = timeData.range.start + (i * timeData.intervalSize);
        final Duration duration = Duration(milliseconds: numValue.toInt());

        final String value = _formatDuration(
          duration,
          timeData.intervalSize.precision > 0,
        );

        final TextPainter painter = _createTextPainter(
          value,
        )..layout();

        if (painter.height > bottomPadding) {
          bottomPadding = painter.height;
        }

        _timePainters.add(painter);
      }
    }

    return EdgeInsets.only(
      left: leftPadding,
      top: topPadding,
      bottom: bottomPadding,
    );
  }

  String _formatDuration(Duration duration, bool showMs) {
    final String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formatted = '$minutes:$seconds';

    if (showMs) {
      formatted += '.${(duration.inMilliseconds.remainder(1000) / 100).floor().toString().padLeft(1, '0')}';
    }

    return formatted;
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

  void paint(Canvas canvas, Rect graphRect) {
    final PictureRecorder recorder = PictureRecorder();
    final Canvas recordedCanvas = Canvas(recorder);

    if (_valueRange != null) {
      _paintValueLegend(recordedCanvas, graphRect);
    }

    _paintTimeLegend(recordedCanvas, graphRect);
  }

  void _paintValueLegend(Canvas canvas, Rect graphRect) {
    final IntervalData? valueData = _valueData;

    if (valueData == null) {
      return;
    }

    final double stepSize = graphRect.height / (_valuePainters.length - 1);

    for (int i = 0; i < _valuePainters.length; i++) {
      final TextPainter painter = _valuePainters[_valuePainters.length - i - 1];

      painter.paint(
        canvas,
        Offset(
          0,
          ((i + 1) * stepSize),
        ),
      );
    }
  }

  void _paintTimeLegend(Canvas canvas, Rect graphRect) {}
}
