import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foreshortening_calculator/model/Model.dart';
import 'package:vector_math/vector_math.dart';

class SquareModel extends Model {
  List<Vector3> linePointsFront;
  List<Vector3> linePointsBack;
  List<Vector3> linePointsMiddle;
  Vector3 middlePoint;

  SquareModel(int gridNumber, int viewerAngle) : super(viewerAngle) {
    linePointsFront = List.filled(gridNumber + 1, Vector3.zero());
    linePointsBack = List.filled(gridNumber + 1, Vector3.zero());
    linePointsMiddle = List.filled(gridNumber + 1, Vector3.zero());
    // x is length of current diagonal
    for (double x = 0; x < linePointsFront.length; ++x) {
      var lengthOfGridSide = x / sqrt2;
      linePointsFront[x.toInt()] =
          new Vector3(lengthOfGridSide, lengthOfGridSide, 0);
      linePointsBack[x.toInt()] = linePointsFront[x.toInt()] +
          new Vector3(gridNumber - x, gridNumber - x, 0);
      linePointsMiddle[x.toInt()] = new Vector3(x, x, 0);
    }

    middlePoint = new Vector3(gridNumber / 2, 0, 0);
  }

  SquareModelRepresentation getRepresentation() {
    return new SquareModelRepresentation(
        getDistanceRatios(linePointsFront),
        getDistanceRatios(linePointsBack),
        getDistanceRatios(linePointsMiddle),
        0);
  }
}

class SquareModelRepresentation {
  final List<double> lineRatiosFront;
  final List<double> lineRatiosBack;
  final List<double> lineRatiosMiddle;
  final double angleBetweenMiddleAndFront;

  SquareModelRepresentation(this.lineRatiosFront, this.lineRatiosBack,
      this.lineRatiosMiddle, this.angleBetweenMiddleAndFront);
}

// ignore: must_be_immutable
class SquareModelWidget extends StatefulWidget {
  TextEditingController _tecAlpha = new TextEditingController();
  TextEditingController _tecGrids = new TextEditingController();
  TextEditingController _tecLengthOfGrid = new TextEditingController();
  TextEditingController _tecModelResult = new TextEditingController();

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
              new Image(image: AssetImage('assets/MiddleLineModel.jpeg')),
              _buildTextField("Alpha: Viewer Angle", widget._tecAlpha),
              _buildTextField("Number of Grids", widget._tecGrids),
              _buildTextField(
                  "Length of one grid in cm", widget._tecLengthOfGrid,
                  isDecimal: true),
              new TextField(
                decoration: new InputDecoration(
                    labelText: "foreshortened length of grids in cm"),
                controller: widget._tecModelResult,
                style: new TextStyle(fontSize: 24),
                maxLines: null,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTecModelResult() {
    var grids = widget._tecGrids.value.text.toString();
    var alpha = widget._tecAlpha.value.text.toString();
    var lengthOfOneGrid = widget._tecLengthOfGrid.value.text.toString();
    if (grids.isEmpty || alpha.isEmpty || lengthOfOneGrid.isEmpty) {
      return;
    }
    var squareRepresentation =
        new SquareModel(int.parse(grids), int.parse(alpha)).getRepresentation();
    setState(() {
      widget._tecModelResult.text =
          squareRepresentation.angleBetweenMiddleAndFront.toString();
    });
  }

  Widget _buildTextField(String name, TextEditingController tec,
      {bool isDecimal = false}) {
    return new TextField(
      decoration: new InputDecoration(labelText: name),
      controller: tec,
      keyboardType: TextInputType
          .number, //TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: <TextInputFormatter>[
        isDecimal
            ? FilteringTextInputFormatter.singleLineFormatter
            : FilteringTextInputFormatter.digitsOnly
      ], // Only numbers can be entered
      onChanged: (String e) => {_updateTecModelResult()},
    );
  }
}
