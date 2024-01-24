import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';
import 'package:forscan_viewer/utils/extensions/data_list_extension.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.data,
    required this.sharedScale,
    required this.range,
  });

  final List<Data> data;
  final bool sharedScale;
  final Range range;

  @override
  void paint(Canvas canvas, Size size) {
    final int duration = data.duration;
    final double totalMinimum = data.minimum;
    final double totalMaximum = data.maximum;

    for (final Data data in this.data) {
      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = data.color
        ..strokeWidth = 2.0;

      final Path path = Path();

      final double minimum = sharedScale ? totalMinimum : data.minimum;
      final double maximum = sharedScale ? totalMaximum : data.maximum;
      final double range = maximum - minimum;
      final Range scaledRange = this.range.scale(0, duration.toDouble());
      final int startEntry = data.getNearestPointIndex(scaledRange.start.toInt());
      final int endEntry = data.getNearestPointIndex(scaledRange.end.toInt());
      final double yScale = size.height / range;
      final double xScale = size.width / scaledRange.range;
      final double yOffset = yScale * minimum;

      if (data.points.isNotEmpty) {
        final DataPoint firstPoint = data.points[startEntry];
        path.moveTo(
          (firstPoint.milliseconds - scaledRange.start) * xScale,
          size.height - (firstPoint.value * yScale) + yOffset,
        );

        for (int i = startEntry + 1; i < endEntry; i++) {
          final DataPoint point = data.points[i];
          path.lineTo(
            (point.milliseconds - scaledRange.start) * xScale,
            size.height - (point.value * yScale) + yOffset,
          );
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return data != oldDelegate.data || range != oldDelegate.range || sharedScale != oldDelegate.sharedScale;
  }
}
