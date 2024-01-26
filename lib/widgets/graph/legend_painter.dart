import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/interval_data.dart';
import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/utils/extensions/double_extension.dart';

class LegendPainter extends CustomPainter {
  const LegendPainter({
    required this.valueIntervalData,
    required this.timeIntervalData,
  });

  final IntervalData? valueIntervalData;
  final IntervalData? timeIntervalData;

  @override
  void paint(Canvas canvas, Size size) {
    final IntervalData? valueIntervalData = this.valueIntervalData;
    final IntervalData? timeIntervalData = this.timeIntervalData;

    if (valueIntervalData != null) {
      _drawValueInterval(size, canvas, valueIntervalData);
    }
    if (timeIntervalData != null) {
      _drawTimeInterval(size, canvas, timeIntervalData);
    }
  }

  void _drawTimeInterval(Size size, Canvas canvas, IntervalData intervalData) {
    final IntervalData(
      range: Range(:double start),
      :double intervalSize,
      :int intervals,
    ) = intervalData;

    final int precision = (intervalSize / 1000).precision;
    for (int i = 0; i < intervals; i++) {
      final double p = i / (intervals - 1);
      final double x = size.width * p;
      final Duration duration = Duration(milliseconds: (start + (intervalSize * i)).toInt());

      String formattedDuration =
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      if (precision > 0) {
        formattedDuration += '.${(duration.inMilliseconds.remainder(1000) / 100).floor().toString().padLeft(1, '0')}';
      }
      _paintValueAt(
        canvas,
        Offset(x, size.height - 24),
        formattedDuration,
      );
    }
  }

  void _drawValueInterval(Size size, Canvas canvas, IntervalData intervalData) {
    final IntervalData(
      range: Range(:double start),
      :double intervalSize,
      :int intervals,
    ) = intervalData;

    final int precision = intervalSize.precision;

    for (int i = 0; i < intervals; i++) {
      final double p = i / (intervals - 1);
      final double y = size.height * (1 - p);
      final double interval = start + (intervalSize * i);
      _paintValueAt(
        canvas,
        Offset(0, y),
        interval.toStringAsFixed(precision),
      );
    }
  }

  void _paintValueAt(Canvas canvas, Offset offset, String value) {
    final TextSpan span = TextSpan(
      text: value,
      style: const TextStyle(
        color: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant LegendPainter oldDelegate) {
    return valueIntervalData != oldDelegate.valueIntervalData || timeIntervalData != oldDelegate.timeIntervalData;
  }
}
