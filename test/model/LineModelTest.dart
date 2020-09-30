import 'package:foreshortening_calculator/model/LineModel.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('create LineModel with a viewer point of 90 angle and test points', () {
    var lineModel = new LineModel(3, 90);

    Vector3 point1 = new Vector3(1.5, 0, 0);
    Vector3 point2 = new Vector3(0.5, 0, 0);
    expect(
        (lineModel.getAngleBetweenPoints(point1, point2) * radians2Degrees)
            .floor(),
        29);
  });

  test('create LineModel and run with 4 grids viewer point of 90 angle', () {
    var lineModel = new LineModel(3, 90);
    var distanceRatios = lineModel.getDistanceRatios();
    expect(distanceRatios.length, 3);
    print(distanceRatios);
  });
}
