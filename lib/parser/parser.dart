import 'dart:isolate';
import 'dart:ui';

import 'package:forscan_viewer/parser/models/colors.dart';

import '_parser.dart';

class CSVParser {
  const CSVParser._();

  static Future<List<Data>> parse(String csvData) async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_parseIsolate, receivePort.sendPort);

    final SendPort sendPort = await receivePort.first;
    final ReceivePort response = ReceivePort();

    sendPort.send(<Object>[csvData, response.sendPort]);

    return await response.first;
  }

  static void _parseIsolate(SendPort initialReplyTo) {
    final ReceivePort port = ReceivePort();

    initialReplyTo.send(port.sendPort);
    port.listen((dynamic message) {
      message as List<Object>;

      final String csvData = message[0] as String;
      final SendPort replyTo = message[1] as SendPort;

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

      replyTo.send(dataList.map((DataIntermediate data) => data.toData()).toList());
    });
  }
}
