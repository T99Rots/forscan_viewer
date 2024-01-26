import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';
import 'package:forscan_viewer/utils/_utils.dart';

import 'graph_legend_renderer.dart';
import 'graph_overlay_painter.dart';
import 'graph_painter.dart';

class Graph extends StatelessWidget {
  const Graph({
    super.key,
    required this.dataList,
    required this.xPosition,
    required this.timeRange,
    required this.sharedScale,
  });

  final List<Data> dataList;
  final double xPosition;
  final Range timeRange;
  final bool sharedScale;

  @override
  Widget build(BuildContext context) {
    final Range scaledRange = timeRange.scale(0, dataList.duration.toDouble());
    final IntervalData? valueIntervalData = IntervalData.compute(dataList.range, 12);
    final IntervalData? timeIntervalData = IntervalData.compute(scaledRange, 20, <int>[1, 2, 5]);

    return ColoredBox(
      color: Colors.grey.shade900,
      child: GraphLegend(
        valueIntervalData: valueIntervalData,
        timeIntervalData: timeIntervalData,
        child: ColoredBox(
          color: Colors.grey.shade800,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: RepaintBoundary(
                  child: ClipRect(
                    child: CustomPaint(
                      painter: GraphPainter(
                        data: dataList,
                        sharedScale: true,
                        timeRange: scaledRange,
                        valueRange: valueIntervalData?.range ?? dataList.range,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: RepaintBoundary(
                  child: ClipRect(
                    child: CustomPaint(
                      painter: GraphOverlayPainter(
                        data: dataList,
                        xPosition: xPosition,
                        sharedScale: true,
                        timeRange: scaledRange,
                        valueRange: valueIntervalData?.range ?? dataList.range,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
