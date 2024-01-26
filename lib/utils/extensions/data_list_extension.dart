import 'package:forscan_viewer/models/range.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

extension DataListExtension on List<Data> {
  Range get range {
    double start = double.infinity;
    double end = double.negativeInfinity;
    for (final Data data in this) {
      if (data.range.start < start) {
        start = data.range.start;
      }
      if (data.range.end > end) {
        end = data.range.end;
      }
    }
    return Range(start, end);
  }

  int get duration {
    int duration = 0;
    for (final Data item in this) {
      if (item.duration > duration) {
        duration = item.duration;
      }
    }
    return duration;
  }
}
