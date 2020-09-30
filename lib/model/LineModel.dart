import 'package:flutter/material.dart';
import 'package:foreshortening_calculator/model/Model.dart';
import 'package:vector_math/vector_math.dart';

class LineModel extends Model {
  List<Vector3> linePoints;
  // create line with center in 0, 0, 0
  // length will be 1 per grid
  LineModel(int gridNumber, int viewerAngle) : super(viewerAngle) {
    print("LineModel");
    linePoints = List.filled(gridNumber + 1, Vector3.zero());
    final double gridNumberHalf = gridNumber.toDouble() / 2;
    print("gridNumberHalf $gridNumberHalf");
    int creationIterator = 0;
    for (var i = 0; i < linePoints.length; ++i) {
      linePoints[i] = new Vector3(gridNumberHalf - creationIterator++, 0, 0);
    }
    for (var o in linePoints) {
      print(o);
    }
  }

  @override
  List<double> getDistanceAngles() {
    print("getDistanceAngles");
    List<double> angles = new List(linePoints.length - 1);
    for (var i = 0; i < linePoints.length - 1; ++i) {
      var point1 = linePoints[i];
      var point2 = linePoints[i + 1];
      angles[i] = getAngleBetweenPoints(point1, point2);
      print("angles $angles");
    }
    return angles;
  }
}

class LineModelWidget extends StatefulWidget {
  @override
  _LineModelWidgetState createState() => _LineModelWidgetState();
}

class _LineModelWidgetState extends State<LineModelWidget> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: Center(
          child: Column(
            children: [
              new Image(image: AssetImage('assets/LineModel.jpg')),
              new Text("abc"),
            ],
          ),
        ),
      ),
    );
  }
}
