import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreshortening_calculator/model/LineModel.dart';
import 'package:vector_math/vector_math.dart';

final List<String> allModelNames = <String>[
  'LineModel',
  'One More',
  'Another',
  "This one"
];

class Model {
  Vector3 viewerPoint;

  Model(int viewerAngle, {int distance = 1}) {
    print("Model");
    double radians = viewerAngle.toDouble() * degrees2Radians;
    double x = distance * cos(radians);
    double y = distance * sin(radians);
    if (viewerAngle == 90) {
      x = 0;
    }
    viewerPoint = new Vector3(x, y, 0);
    print("radians $radians viewerPoint is $viewerPoint");
  }

  List<double> getDistanceRatios() {
    print("getDistanceRatios");
    List<double> distanceAngles = getDistanceAngles();
    print("distanceAngles $distanceAngles");
    List<double> anglesRatios = new List(distanceAngles.length);
    double sumOfAngles = distanceAngles.fold(
        0, (previousValue, element) => previousValue + element);
    for (var i = 0; i < distanceAngles.length; ++i) {
      anglesRatios[i] = distanceAngles[i] / sumOfAngles;
    }
    return anglesRatios;
  }

  List<double> getDistanceAngles() {
    print("getDistanceAngles UnimplementedError");
    throw UnimplementedError();
  }

  double getAngleBetweenPoints(Vector3 point1, Vector3 point2) {
    print("getAngleBetweenPoints");
    Vector3 a = point1 + viewerPoint;
    Vector3 b = point2 + viewerPoint;
    print("angle between $point1 $point2 and respectively $a $b ");
    double n = a.length * b.length;
    double dot = dot3(a, b);
    double angleInRadians = acos(dot / n);
    print("n $n dot $dot angleInRadians $angleInRadians");
    return angleInRadians;
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

enum ModelsEnum { lineModel, squareModel }

class ModelFactory {
  static StatefulWidget model(ModelsEnum model) {
    switch (model) {
      case ModelsEnum.lineModel:
        return LineModelWidget();
      case ModelsEnum.squareModel:
        // TODO enter square model
        return LineModelWidget();
      default:
        throw new UnimplementedError();
    }
  }

  static String name(ModelsEnum model) {
    switch (model) {
      case ModelsEnum.lineModel:
        return "Line Model";
      case ModelsEnum.squareModel:
        return "Square Model";
      default:
        throw new UnimplementedError();
    }
  }
}
