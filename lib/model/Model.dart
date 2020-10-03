import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreshortening_calculator/model/LineModel.dart';
import 'package:vector_math/vector_math.dart';

import 'SquareModel.dart';

final List<String> allModelNames = <String>[
  'LineModel',
  'One More',
  'Another',
  "This one"
];

abstract class Model {
  Vector3 viewerPoint;

  Model(int viewerAngle, {int distance = 1}) {
    double radians = viewerAngle.toDouble() * degrees2Radians;
    double x = distance * cos(radians);
    double z = distance * sin(radians);
    if (viewerAngle == 90) {
      x = 0;
    }
    viewerPoint = new Vector3(x, 0, z);
  }

  getRepresentation();

  double getAngleBetweenPoints(Vector3 point1, Vector3 point2) {
    return getAngleBetweenPointsWithViewer(viewerPoint, point1, point2);
  }

  double getAngleBetweenPointsWithViewer(
      Vector3 viewer, Vector3 point1, Vector3 point2) {
    Vector3 a = point1 + viewer;
    Vector3 b = point2 + viewer;
    double n = a.length * b.length;
    double dot = dot3(a, b);
    double angleInRadians = acos(dot / n);
    return angleInRadians;
  }

  List<double> getDistanceAngles(List<Vector3> linePoints) {
    List<double> angles = new List(linePoints.length - 1);
    for (var i = 0; i < linePoints.length - 1; ++i) {
      var point1 = linePoints[i];
      var point2 = linePoints[i + 1];
      angles[i] = getAngleBetweenPoints(point1, point2);
    }
    return angles;
  }

  List<double> getDistanceRatios(List<Vector3> linePoints) {
    List<double> distanceAngles = getDistanceAngles(linePoints);
    List<double> anglesRatios = new List(distanceAngles.length);
    double sumOfAngles = distanceAngles.fold(
        0, (previousValue, element) => previousValue + element);
    for (var i = 0; i < distanceAngles.length; ++i) {
      anglesRatios[i] = distanceAngles[i] / sumOfAngles;
    }
    return anglesRatios;
  }
}

class ModelWidget extends StatefulWidget {
  final modelEnum;
  ModelWidget(this.modelEnum);

  @override
  _ModelWidgetState createState() => _ModelWidgetState();
}

class _ModelWidgetState extends State<ModelWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text(ModelFactory.name(widget.modelEnum)),
          leading: new BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ModelFactory.model((widget.modelEnum)),
      ),
    );
  }
}

enum ModelsEnum { lineModel, middleLineModel, squareModel }

class ModelFactory {
  static var lineModelWidget = LineModelWidget(false);
  static var middleLineModel = LineModelWidget(true);
  static var squareModel = SquareModelWidget();

  static StatefulWidget model(ModelsEnum model) {
    switch (model) {
      case ModelsEnum.lineModel:
        return lineModelWidget;
      case ModelsEnum.middleLineModel:
        return middleLineModel;
      case ModelsEnum.squareModel:
        return squareModel;
      default:
        throw new UnimplementedError();
    }
  }

  static String name(ModelsEnum model) {
    switch (model) {
      case ModelsEnum.lineModel:
        return "Line Model";
      case ModelsEnum.middleLineModel:
        return "Line Model (Viewer at the Middle)";
      case ModelsEnum.squareModel:
        return "Square Model";
      default:
        throw new UnimplementedError();
    }
  }
}
