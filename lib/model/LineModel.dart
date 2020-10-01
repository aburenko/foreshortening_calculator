import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// ignore: must_be_immutable
class LineModelWidget extends StatefulWidget {
  TextEditingController _tecAlpha = new TextEditingController();
  TextEditingController _tecGrids = new TextEditingController();
  TextEditingController _tecLengthOfGrid = new TextEditingController();
  TextEditingController _tecModelResult = new TextEditingController();
  final bool _isMiddle;
  LineModelWidget(this._isMiddle);

  @override
  _LineModelWidgetState createState() => _LineModelWidgetState();
}

class _LineModelWidgetState extends State<LineModelWidget> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(widget._isMiddle),
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

  void _updateTecModelResult() {
    var grids = widget._tecGrids.value.text.toString();
    var alpha = widget._tecAlpha.value.text.toString();
    var lengthOfOneGrid = widget._tecLengthOfGrid.value.text.toString();
    if (grids.isEmpty || alpha.isEmpty || lengthOfOneGrid.isEmpty) {
      return;
    }
    var parse = int.parse(grids);
    var ratiosString =
        new LineModel(int.parse(grids), int.parse(alpha), widget._isMiddle)
            .getDistanceRatios();
    var distances = ratiosString
        .map((e) =>
            (e.toDouble() * double.parse(lengthOfOneGrid)).toStringAsFixed(2))
        .toList();
    setState(() {
      widget._tecModelResult.text = distances.toString();
    });
  }

  Widget _buildImage(bool isMiddle) {
    return isMiddle
        ? new Image(image: AssetImage('assets/MiddleLineModel.jpeg'))
        : new Image(image: AssetImage('assets/LineModel.jpg'));
  }
}
