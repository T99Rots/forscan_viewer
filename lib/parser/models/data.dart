import 'dart:ui';

import '_models.dart';

class Data {
  const Data({
    required this.maximum,
    required this.minimum,
    required this.points,
    required this.name,
    required this.fullName,
    required this.unit,
    required this.duration,
    required this.color,
  });

  final List<DataPoint> points;
  final double minimum;
  final double maximum;
  final String name;
  final String fullName;
  final String? unit;
  final int duration;
  final Color color;

  int getNearestPointIndex(int milliseconds) {
    int start = 0;
    int end = points.length - 1;

    while (start <= end) {
      final int mid = start + ((end - start) >> 1);
      if (points[mid].milliseconds == milliseconds) {
        return mid;
      } else if (points[mid].milliseconds < milliseconds) {
        start = mid + 1;
      } else {
        end = mid - 1;
      }
    }

    // If no exact match is found, find the closest one
    if (start >= points.length) {
      return end;
    } else if (end < 0) {
      return start;
    } else {
      // Return the index of the closest of the two
      return (points[start].milliseconds - milliseconds).abs() < (points[end].milliseconds - milliseconds).abs()
          ? start
          : end;
    }
  }

  DataPoint getNearestPoint(int milliseconds) {
    return points[getNearestPointIndex(milliseconds)];
  }
}
