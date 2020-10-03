import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:foreshortening_calculator/model/Model.dart';
import 'package:vector_math/vector_math.dart';

class SquareModel extends Model {
  List<Vector3> linePointsFront;
  List<Vector3> linePointsBack;
  List<Vector3> linePointsMiddle;
  Vector3 middlePoint;

  SquareModel(int gridNumber, int viewerAngle, int distanceToObject)
      : super(viewerAngle, distance: distanceToObject) {
    linePointsFront = List.filled(gridNumber + 1, Vector3.zero());
    linePointsBack = List.filled(gridNumber + 1, Vector3.zero());
    linePointsMiddle = List.filled(gridNumber + 1, Vector3.zero());
    // x is length of current diagonal
    for (double x = 0; x < linePointsFront.length; ++x) {
      linePointsFront[x.toInt()] = new Vector3(x * 0.5, x * 0.5, 0);
      linePointsBack[linePointsFront.length - x.toInt() - 1] =
          linePointsFront[x.toInt()] +
              new Vector3(gridNumber - x, gridNumber - x, 0);
      //linePointsBack = linePointsBack.reversed;
      linePointsMiddle[x.toInt()] = new Vector3(x, 0, 0);
    }

    print("front ${linePointsFront.toString()}");
    print("back ${linePointsBack.toString()}");
    print("middle ${linePointsMiddle.toString()}");
    middlePoint = new Vector3(gridNumber / 2, 0, 0);
  }

  SquareModelRepresentation getRepresentation() {
    var distanceAnglesFront = getDistanceAngles(linePointsFront);
    var distanceAnglesBack = getDistanceAngles(linePointsBack);
    var distanceAnglesMiddle = getDistanceAngles(linePointsMiddle);
    print("front ${distanceAnglesFront.toString()}");
    print("back ${distanceAnglesBack.toString()}");
    print("middle ${distanceAnglesMiddle.toString()}");

    var lengthFront =
        distanceAnglesFront.reduce((value, element) => value + element);
    var lengthBack =
        distanceAnglesBack.reduce((value, element) => value + element);
    var lengthMiddle =
        distanceAnglesMiddle.reduce((value, element) => value + element);
    print("front $lengthFront");
    print("back $lengthBack");
    print("middle $lengthMiddle");

    return new SquareModelRepresentation(
        getDistanceRatios(linePointsFront),
        getDistanceRatios(linePointsBack),
        getDistanceRatios(linePointsMiddle),
        (acos((pow(lengthFront, 2) +
                        pow(lengthMiddle, 2) -
                        pow(lengthBack, 2)) /
                    (2 * lengthFront * lengthMiddle)) *
                radians2Degrees)
            .toStringAsFixed(1));
  }
}

class SquareModelRepresentation {
  final List<double> lineRatiosFront;
  final List<double> lineRatiosBack;
  final List<double> lineRatiosMiddle;
  final String angleBetweenMiddleAndFront;

  SquareModelRepresentation(this.lineRatiosFront, this.lineRatiosBack,
      this.lineRatiosMiddle, this.angleBetweenMiddleAndFront);
}

// ignore: must_be_immutable
class SquareModelWidget extends StatefulWidget {
  TextEditingController _tecAlpha = new TextEditingController();
  TextEditingController _tecGrids = new TextEditingController();
  TextEditingController _tecLengthOfGrid = new TextEditingController();

  TextEditingController _tecAngleResult = new TextEditingController();
  TextEditingController _tecFrontResult = new TextEditingController();
  TextEditingController _tecBackResult = new TextEditingController();
  TextEditingController _tecMiddleResult = new TextEditingController();

  @override
  _SquareModelWidgetState createState() => _SquareModelWidgetState();
}

class _SquareModelWidgetState extends State<SquareModelWidget> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              new Image(image: AssetImage('assets/SquareModel.jpg')),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputWidget(widget._tecGrids, widget._tecAlpha,
                        widget._tecLengthOfGrid, _updateModel),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: new Text("Results",
                          style: new TextStyle(fontSize: 25)),
                    ),
                    Material(
                      color: m.Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: m.Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildResultTextField(
                                "angle b/w middle and front line",
                                widget._tecAngleResult),
                            buildResultTextField(
                                "front line", widget._tecFrontResult),
                            buildResultTextField(
                                "middle line", widget._tecMiddleResult),
                            buildResultTextField(
                                "back line", widget._tecBackResult),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateModel() {
    var grids = widget._tecGrids.value.text.toString();
    var alpha = widget._tecAlpha.value.text.toString();
    var lengthOfOneGrid = widget._tecLengthOfGrid.value.text.toString();
    if (grids.isEmpty || alpha.isEmpty || lengthOfOneGrid.isEmpty) {
      return;
    }
    var representation = new SquareModel(int.parse(grids), int.parse(alpha), 10)
        .getRepresentation();
    double gridLen = double.parse(lengthOfOneGrid);
    setState(() {
      widget._tecAngleResult.text = representation.angleBetweenMiddleAndFront;
      widget._tecFrontResult.text =
          fromList(representation.lineRatiosFront, gridLen);
      widget._tecMiddleResult.text =
          fromList(representation.lineRatiosMiddle, gridLen);
      widget._tecBackResult.text =
          fromList(representation.lineRatiosBack, gridLen);
    });
  }

  String fromList(List<double> list, double gridLen) {
    return list.map((e) => (e * gridLen).toStringAsFixed(3)).join(", ");
  }
}
