class Range {
  const Range(
    this.start,
    this.end,
  );

  static const Range full = Range(0, 1);

  final double start;
  final double end;

  Range scale(double min, double max) {
    final double distance = max - min;

    return Range(
      (start * distance) + min,
      (end * distance) + min,
    );
  }

  Range zoom(double at, double amount, {Range? bounds}) {
    final double newRange;

    if (amount > 0) {
      newRange = range / (amount + 1);
    } else {
      newRange = range * (-amount + 1);
    }

    final double difference = range - newRange;

    final double newStart = start + (difference * at);
    final double newEnd = end - (difference * (1 - at));

    if (bounds != null) {
      if (bounds.range < newRange) {
        return bounds;
      }

      if (newEnd > bounds.end) {
        return Range(bounds.end - newRange, bounds.end);
      }

      if (newStart < bounds.start) {
        return Range(bounds.start, bounds.start + newRange);
      }
    }

    return Range(newStart, newEnd);
  }

  double valueAt(double at) {
    return range * at + start;
  }

  double get range => end - start;

  @override
  String toString() {
    return 'Range($start, $end)';
  }

  @override
  bool operator ==(Object other) => other is Range && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(
        start,
        end,
      );
}
