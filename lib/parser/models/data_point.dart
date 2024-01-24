class DataPoint {
  const DataPoint({
    required this.milliseconds,
    required this.value,
  });

  final int milliseconds;
  final double value;

  String get valueString => value.toString();
}
