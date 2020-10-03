import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:foreshortening_calculator/model/Model.dart';
import 'package:vector_math/vector_math.dart';

class LineModel extends Model {
  List<Vector3> linePoints;
  // create line with center in 0, 0, 0
  // length will be 1 per grid
  LineModel(
      int gridNumber, int viewerAngle, bool isMiddle, int distanceToObject)
      : super(viewerAngle, distance: distanceToObject) {
    _constructedLinePoints(-gridNumber.toDouble() / 2, gridNumber);
  }

  LineModel.middle(int gridNumber, int viewerAngle, int distanceToObject)
      : super(viewerAngle, distance: distanceToObject) {
    linePoints = List.filled(gridNumber + 1, Vector3.zero());
    _constructedLinePoints(0, gridNumber);
  }

  void _constructedLinePoints(double lineStaringX, int gridNumber) {
    linePoints = List.filled(gridNumber + 1, Vector3.zero());
    for (var i = 0; i < linePoints.length; ++i) {
      linePoints[i] = new Vector3(lineStaringX + i, 0, 0);
    }
  }

  List<double> getRepresentation() {
    return getDistanceRatios(linePoints);
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
                            new TextField(
                              decoration: new InputDecoration(
                                  labelText: "foreshortened length of grids"),
                              controller: widget._tecModelResult,
                              style: new TextStyle(fontSize: 24),
                              maxLines: null,
                              enabled: false,
                            ),
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

  Widget _buildImage(bool isMiddle) {
    return isMiddle
        ? new Image(image: AssetImage('assets/MiddleLineModel.jpeg'))
        : new Image(image: AssetImage('assets/LineModel.jpg'));
  }

  void _updateModel() {
    var grids = widget._tecGrids.value.text.toString();
    var alpha = widget._tecAlpha.value.text.toString();
    var lengthOfOneGrid = widget._tecLengthOfGrid.value.text.toString();
    if (grids.isEmpty || alpha.isEmpty || lengthOfOneGrid.isEmpty) {
      return;
    }
    var ratiosString =
        new LineModel(int.parse(grids), int.parse(alpha), widget._isMiddle, 10)
            .getRepresentation();
    var distances = ratiosString
        .map((e) =>
            (e.toDouble() * double.parse(lengthOfOneGrid)).toStringAsFixed(2))
        .join(", ");
    setState(() {
      widget._tecModelResult.text = distances.toString();
    });
  }
}
