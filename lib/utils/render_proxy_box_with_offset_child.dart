import 'package:flutter/rendering.dart';

abstract class RenderProxyBoxWithOffsetChild extends RenderProxyBox {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    if (child == null) {
      return;
    }

    final BoxParentData parentData = child.parentData as BoxParentData;
    context.paintChild(child, parentData.offset + offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? child = this.child;
    if (child == null) {
      return false;
    }

    final BoxParentData parentData = child.parentData as BoxParentData;

    return result.addWithPaintOffset(
      offset: parentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return child.hitTest(
          result,
          position: transformed,
        );
      },
    );
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return 0.0;
    }

    final double? result = child.getDistanceToActualBaseline(baseline);
    if (result != null) {
      final BoxParentData parentData = child.parentData as BoxParentData;

      return result + parentData.offset.dy;
    }

    return null;
  }

  BoxParentData? get childParentData => child?.parentData as BoxParentData?;
}
