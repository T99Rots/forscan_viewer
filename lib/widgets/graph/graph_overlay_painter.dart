import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

class GraphOverlayPainter extends CustomPainter {
  const GraphOverlayPainter({
    required this.xPosition,
    required this.data,
    required this.sharedScale,
    required this.timeRange,
    required this.valueRange,
  });

  final double xPosition;
  final List<Data> data;
  final bool sharedScale;
  final Range timeRange;
  final Range valueRange;

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

    final List<_TextValue> textValues = <_TextValue>[];
    double maxWidth = 0;

    for (final Data data in data) {
      // Get point at current position and get y scale.
      final Range(
        :double start,
        :double range,
      ) = sharedScale ? valueRange : data.range;

      final double yScale = size.height / range;
      final double yOffset = yScale * start;

      final int ms = timeRange.valueAt(xPosition / size.width).toInt();
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

      if (!sharedScale) {
        fullValue += ' (${data.name})';
      }

      final TextSpan span = TextSpan(
        text: fullValue,
        style: TextStyle(color: data.color, backgroundColor: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
    return oldDelegate.xPosition != xPosition ||
        oldDelegate.timeRange != timeRange ||
        oldDelegate.data != data ||
        oldDelegate.sharedScale != sharedScale;
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
