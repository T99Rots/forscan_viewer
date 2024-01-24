import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/data.dart';
import 'package:forscan_viewer/widgets/graph/graph.dart';

class GraphList extends StatefulWidget {
  const GraphList({
    super.key,
    required this.dataList,
    required this.separatedGraphs,
  });

  final List<Data> dataList;
  final bool separatedGraphs;

  @override
  State<GraphList> createState() => _GraphListState();
}

class _GraphListState extends State<GraphList> {
  final FocusNode focusNode = FocusNode();
  double xPosition = 0;
  Range range = Range.full;
  bool _ctrlPressed = false;
  Duration _lastScrollTime = Duration.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Listener(
          onPointerSignal: (PointerSignalEvent event) {
            if (event is! PointerScrollEvent || !_ctrlPressed) {
              return;
            }
            if (event.timeStamp - _lastScrollTime < const Duration(milliseconds: 10)) {
              _lastScrollTime = event.timeStamp;
              return;
            }

            _lastScrollTime = event.timeStamp;

            final double at = xPosition / constraints.maxWidth;

            if (event.scrollDelta.dy < 0) {
              range = range.zoom(at, 0.25, bounds: Range.full);
            } else {
              range = range.zoom(at, -0.25, bounds: Range.full);
            }

            setState(() {});
          },
          child: RawKeyboardListener(
            autofocus: true,
            focusNode: focusNode,
            onKey: (RawKeyEvent event) {
              switch (event) {
                case RawKeyDownEvent(logicalKey: LogicalKeyboardKey.controlLeft || LogicalKeyboardKey.controlRight):
                  _ctrlPressed = true;
                  break;
                case RawKeyUpEvent(logicalKey: LogicalKeyboardKey.controlLeft || LogicalKeyboardKey.controlRight):
                  _ctrlPressed = false;
              }
            },
            child: MouseRegion(
              onHover: (PointerHoverEvent event) {
                xPosition = event.localPosition.dx;
                setState(() {});
              },
              child: _buildContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (widget.separatedGraphs) {
      return ListView(
        physics: _ctrlPressed ? const NeverScrollableScrollPhysics() : null,
        children: widget.dataList
            .map(
              (Data data) => _buildGraph(data),
            )
            .toList(),
      );
    }

    return Graph(
      data: widget.dataList,
      xPosition: xPosition,
      range: range,
    );
  }

  SizedBox _buildGraph(Data data) {
    return SizedBox(
      height: 400,
      child: Graph(
        data: <Data>[data],
        xPosition: xPosition,
        range: range,
      ),
    );
  }
}
