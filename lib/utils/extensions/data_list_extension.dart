import 'package:forscan_viewer/parser/models/_models.dart';

extension DataListExtension on List<Data> {
  double get minimum {
    double minimum = double.infinity;
    for (final Data item in this) {
      if (item.minimum < minimum) {
        minimum = item.minimum;
      }
    }
    return minimum;
  }

  double get maximum {
    double maximum = double.negativeInfinity;
    for (final Data item in this) {
      if (item.maximum > maximum) {
        maximum = item.maximum;
      }
    }
    return maximum;
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
