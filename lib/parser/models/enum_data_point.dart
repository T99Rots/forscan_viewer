import '_models.dart';

class EnumDataPoint extends DataPoint {
  EnumDataPoint({
    required super.milliseconds,
    required super.value,
    required this.valueString,
  });

  @override
  final String valueString;
}
