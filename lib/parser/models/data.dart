import 'dart:math';
import 'dart:ui';

import 'package:forscan_viewer/models/range.dart';

import '_models.dart';

class Data {
  const Data({
    required this.range,
    required this.points,
    required this.name,
    required this.fullName,
    required this.unit,
    required this.duration,
    required this.color,
    required this.index,
  });

  final List<DataPoint> points;
  final Range range;
  final String name;
  final String fullName;
  final String? unit;
  final int duration;
  final Color color;
  final int index;

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

  int getNearestPointIndexAbove(int milliseconds) {
    final int index = getNearestPointIndex(milliseconds);

    if (points[index].milliseconds < milliseconds) {
      return min(points.length - 1, index + 1);
    }

    return index;
  }

  int getNearestPointIndexBelow(int milliseconds) {
    final int index = getNearestPointIndex(milliseconds);

    if (points[index].milliseconds > milliseconds) {
      return max(0, index - 1);
    }

    return index;
  }

  DataPoint getNearestPoint(int milliseconds) {
    return points[getNearestPointIndex(milliseconds)];
  }
}
