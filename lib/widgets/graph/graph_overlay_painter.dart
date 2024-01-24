import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';
import 'package:forscan_viewer/utils/_utils.dart';

class GraphOverlayPainter extends CustomPainter {
  const GraphOverlayPainter({
    required this.xPosition,
    required this.data,
    required this.sharedScale,
    required this.range,
  });

  final double xPosition;
  final List<Data> data;
  final bool sharedScale;
  final Range range;

  static const double _textPadding = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(xPosition, 0),
      Offset(xPosition, size.height),
      paint,
    );

    final int duration = data.duration;
    final double totalMinimum = data.minimum;
    final double totalMaximum = data.maximum;

    final List<_TextValue> textValues = <_TextValue>[];
    double maxWidth = 0;

    for (final Data data in data) {
      // Get point at current position and get y scale.
      final double minimum = sharedScale ? totalMinimum : data.minimum;
      final double maximum = sharedScale ? totalMaximum : data.maximum;
      final double range = maximum - minimum;
      final Range scaledRange = this.range.scale(0, duration.toDouble());
      final double yScale = size.height / range;
      final double yOffset = yScale * minimum;

      final int ms = scaledRange.valueAt(xPosition / size.width).toInt();
      final DataPoint point = data.getNearestPoint(ms);

      // Paint point at current point.
      final Paint paint = Paint()..strokeWidth = 2.0;

      canvas.drawCircle(
        Offset(
          xPosition,
          size.height - (point.value * yScale) + yOffset,
        ),
        5,
        paint,
      );

      paint.color = data.color;

      canvas.drawCircle(
        Offset(
          xPosition,
          size.height - (point.value * yScale) + yOffset,
        ),
        3,
        paint,
      );

      // Create text painter for the current value.
      String fullValue = point.valueString;
      final String? unit = data.unit;
      if (unit != null) {
        fullValue += unit;
      }

      final TextSpan span = TextSpan(
        text: fullValue,
        style: TextStyle(
          color: data.color,
          backgroundColor: Colors.black,
          fontSize: 16,
        ),
      );

      final TextPainter painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      textValues.add(_TextValue(
        y: size.height - (point.value * yScale) - (painter.height / 2) + yOffset,
        painter: painter,
      ));

      if (painter.width > maxWidth) {
        maxWidth = painter.width;
      }
    }

    textValues.sort((_TextValue a, _TextValue b) => a.y.compareTo(b.y));

    double lastY = double.negativeInfinity;
    for (final _TextValue textValue in textValues) {
      if (textValue.y < 0) {
        textValue.y = 0;
      }

      if (textValue.y - textValue.painter.height < lastY) {
        textValue.y = lastY + textValue.painter.height;
      }

      if (textValue.y + textValue.painter.height > size.height) {
        textValue.y = size.height - textValue.painter.height;
      }

      lastY = textValue.y;
    }

    lastY = double.infinity;
    for (final _TextValue textValue in textValues.reversed) {
      if (textValue.y + textValue.painter.height > size.height) {
        textValue.y = size.height - textValue.painter.height;
      }

      if (textValue.y + textValue.painter.height > lastY) {
        textValue.y = lastY - textValue.painter.height;
      }

      if (textValue.y < 0) {
        textValue.y = 0;
      }

      lastY = textValue.y;
    }

    final bool rightSide = _textPadding + maxWidth + xPosition < size.width;
    for (final _TextValue(:double y, :TextPainter painter) in textValues) {
      final double xOffset;
      if (rightSide) {
        xOffset = _textPadding + xPosition;
      } else {
        xOffset = xPosition - _textPadding - painter.width;
      }

      painter.paint(
        canvas,
        Offset(
          xOffset,
          y,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GraphOverlayPainter oldDelegate) {
    return oldDelegate.xPosition != xPosition;
  }
}

class _TextValue {
  _TextValue({
    required this.painter,
    required this.y,
  });

  double y;
  TextPainter painter;
}
