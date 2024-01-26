import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forscan_viewer/models/_models.dart';
import 'package:forscan_viewer/parser/models/data.dart';
import 'package:forscan_viewer/utils/extensions/_extensions.dart';
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
  final FocusNode _focusNode = FocusNode();
  double _xPosition = 0;
  Range _range = Range.full;
  bool _ctrlPressed = false;
  bool _shiftPressed = false;
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
            if (event is! PointerScrollEvent) {
              return;
            }

            if (_ctrlPressed) {
              if (event.timeStamp - _lastScrollTime < const Duration(milliseconds: 10)) {
                _lastScrollTime = event.timeStamp;
                return;
              }
              _lastScrollTime = event.timeStamp;

              final double at = _xPosition / constraints.maxWidth;

              final double maxZoom = widget.dataList.duration / 5000;

              if (event.scrollDelta.dy < 0) {
                _range = _range.zoom(at, 0.25, Range.full, maxZoom);
              } else {
                _range = _range.zoom(at, -0.25, Range.full, maxZoom);
              }

              setState(() {});
            } else if (_shiftPressed) {
              _range = _range.translate(
                event.scrollDelta.dy * 0.001,
                bounds: Range.full,
              );
              setState(() {});
            }
          },
          child: RawKeyboardListener(
            autofocus: true,
            focusNode: _focusNode,
            onKey: (RawKeyEvent event) {
              switch (event) {
                case RawKeyDownEvent(logicalKey: LogicalKeyboardKey.controlLeft || LogicalKeyboardKey.controlRight):
                  _ctrlPressed = true;
                  break;
                case RawKeyUpEvent(logicalKey: LogicalKeyboardKey.controlLeft || LogicalKeyboardKey.controlRight):
                  _ctrlPressed = false;
                  break;
                case RawKeyDownEvent(logicalKey: LogicalKeyboardKey.shiftLeft || LogicalKeyboardKey.shiftRight):
                  _shiftPressed = true;
                  break;
                case RawKeyUpEvent(logicalKey: LogicalKeyboardKey.shiftLeft || LogicalKeyboardKey.shiftRight):
                  _shiftPressed = false;
                  break;
              }
            },
            child: MouseRegion(
              onHover: (PointerHoverEvent event) {
                _xPosition = event.localPosition.dx;
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
        physics: _ctrlPressed || _shiftPressed ? const NeverScrollableScrollPhysics() : null,
        children: widget.dataList
            .map(
              (Data data) => _buildGraph(data),
            )
            .toList(),
      );
    }

    return Graph(
      dataList: widget.dataList,
      xPosition: _xPosition,
      timeRange: _range,
      sharedScale: false,
    );
  }

  SizedBox _buildGraph(Data data) {
    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.fullName,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: Graph(
              dataList: <Data>[data],
              xPosition: _xPosition,
              timeRange: _range,
              sharedScale: true,
            ),
          ),
        ],
      ),
    );
  }
}
