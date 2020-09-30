import 'dart:math';

import 'package:vector_math/vector_math.dart';

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
    Vector3 a = viewerPoint - point1;
    Vector3 b = viewerPoint - point2;
    double n = a.normalize() * b.normalize();
    double dot = dot3(a, b);
    double angleInRadians = acos(dot / n);
    print("angle between $a $point1 and $b $point2 is $angleInRadians");
    print("n $n dot $dot angleInRadians $angleInRadians");
    return angleInRadians;
  }
}
