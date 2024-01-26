import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.data,
    required this.sharedScale,
    required this.timeRange,
    required this.valueRange,
  });

  final List<Data> data;
  final bool sharedScale;
  final Range timeRange;
  final Range valueRange;

  static const double strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final Data data in this.data) {
      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = data.color
        ..strokeWidth = 2.0;

      final Path path = Path();

      final Range(
        :double start,
        :double range,
      ) = sharedScale ? valueRange : data.range;
      final int startEntry = data.getNearestPointIndexBelow(timeRange.start.toInt());
      final int endEntry = data.getNearestPointIndexAbove(timeRange.end.toInt());
      final double yScale = (size.height - strokeWidth) / range;
      final double xScale = size.width / timeRange.range;
      final double yOffset = yScale * start - (strokeWidth / 2);

      if (data.points.isNotEmpty) {
        final DataPoint firstPoint = data.points[startEntry];
        path.moveTo(
          (firstPoint.milliseconds - timeRange.start) * xScale,
          size.height - (firstPoint.value * yScale) + yOffset,
        );

        for (int i = startEntry + 1; i < endEntry; i++) {
          final DataPoint point = data.points[i];
          path.lineTo(
            (point.milliseconds - timeRange.start) * xScale,
            size.height - (point.value * yScale) + yOffset,
          );
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) =>
      timeRange != oldDelegate.timeRange ||
      sharedScale != oldDelegate.sharedScale ||
      !listEquals(data, oldDelegate.data);
}
