import 'package:flutter/material.dart';
import 'package:foreshortening_calculator/model/Model.dart';
import 'package:vector_math/vector_math.dart';

class LineModel extends Model {
  List<Vector3> linePoints;
  // create line with center in 0, 0, 0
  // length will be 1 per grid
  LineModel(int gridNumber, int viewerAngle, bool isMiddle)
      : super(viewerAngle) {
    linePoints = List.filled(gridNumber + 1, Vector3.zero());
    double gridNumberHalf = -gridNumber.toDouble() / 2;
    if (!isMiddle) {
      gridNumberHalf = 0;
    }
    int creationIterator = 0;
    for (var i = 0; i < linePoints.length; ++i) {
      linePoints[i] = new Vector3(gridNumberHalf + creationIterator++, 0, 0);
    }
  }

  @override
  List<double> getDistanceAngles() {
    List<double> angles = new List(linePoints.length - 1);
    for (var i = 0; i < linePoints.length - 1; ++i) {
      var point1 = linePoints[i];
      var point2 = linePoints[i + 1];
      angles[i] = getAngleBetweenPoints(point1, point2);
    }
    return angles;
  }
}

class SquareModelWidget extends StatefulWidget {
  @override
  _SquareModelWidgetState createState() => _SquareModelWidgetState();
}

class _SquareModelWidgetState extends State<SquareModelWidget> {
  @override
  Widget build(BuildContext context) {
    return new Text("todo");
  }
}
