import 'package:flutter/material.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/_models.dart';

import 'graph_overlay_painter.dart';
import 'graph_painter.dart';

class Graph extends StatelessWidget {
  const Graph({
    super.key,
    required this.data,
    required this.xPosition,
    required this.range,
  });

  final List<Data> data;
  final double xPosition;
  final Range range;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: GraphPainter(
                data: data,
                sharedScale: true,
                range: range,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: GraphOverlayPainter(
                data: data,
                xPosition: xPosition,
                sharedScale: true,
                range: range,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
