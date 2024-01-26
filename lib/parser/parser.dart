import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:forscan_viewer/parser/models/colors.dart';

import '_parser.dart';

class CSVParser {
  const CSVParser._();

  static Future<List<Data>> parse(String csvData) async {
    return compute(_parse, csvData);
  }

  static List<Data> _parse(String csvData) {
    final List<String> rows = csvData.split('\n');

    final List<DataIntermediate> dataList = <DataIntermediate>[];

    final List<String> names = rows[0].split(';');
    for (int i = 1; i < names.length; i++) {
      final String name = names[i];
      final Color color = colors[i];

      dataList.add(
        DataIntermediate(
          name: name,
          color: color,
          index: i,
        ),
      );
    }

    for (int i = 1; i < rows.length; i++) {
      if (rows[i].isEmpty) {
        continue;
      }
      final List<String> values = rows[i].split(';');
      final int milliseconds = int.parse(values[0]);
      for (int i = 1; i < values.length; i++) {
        final String value = values[i];

        if (value == '-') {
          continue;
        }

        dataList[i - 1].addPoint(milliseconds, value);
      }
    }

    return dataList.map((DataIntermediate data) => data.toData()).toList();
  }
}
