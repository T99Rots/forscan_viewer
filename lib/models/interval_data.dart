import '_models.dart';

class IntervalData {
  const IntervalData({
    required this.intervalSize,
    required this.intervals,
    required this.range,
  });

  static const List<int> _steps = <int>[1, 2, 3, 5];

  static IntervalData? compute(Range range, int maxIntervals, [List<int> steps = _steps]) {
    for (double magnitude = 1; magnitude < 1e15; magnitude *= 10) {
      for (final int step in steps) {
        final double intervalSize = step * (magnitude / 1000);
        final double start = (range.start / intervalSize).floor() * intervalSize;
        final double end = (range.end / intervalSize).ceil() * intervalSize;
        final int intervals = ((end - start) ~/ intervalSize) + 1;

        if (intervals < maxIntervals) {
          return IntervalData(
            range: Range(start, end),
            intervalSize: intervalSize,
            intervals: intervals,
          );
        }
      }
    }

    return null;
  }

  final Range range;
  final double intervalSize;
  final int intervals;
}
