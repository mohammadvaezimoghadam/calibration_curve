import 'dart:math';


import 'data/chartData.dart';

double findSlope(List<ChartData> dataPoints) {
  double xSum = 0;
  double ySum = 0;
  double xySum = 0;
  double xSquareSum = 0;

  for (int i = 0; i < dataPoints.length; i++) {
    xSum += dataPoints[i].x;
    ySum += dataPoints[i].y;
    xySum += dataPoints[i].x * dataPoints[i].y;
    xSquareSum += pow(dataPoints[i].x, 2);
  }

  double slope =
      (dataPoints.length * xySum - xSum * ySum) / (dataPoints.length * xSquareSum - pow(xSum, 2));

  return slope;
}

double findIntercept(List<ChartData> dataPoints, double slope) {
  double xSum = 0;
  double ySum = 0;

  for (int i = 0; i < dataPoints.length; i++) {
    xSum += dataPoints[i].x;
    ySum += dataPoints[i].y;
  }

  double yMean = ySum / dataPoints.length;
  double xMean = xSum / dataPoints.length;

  double intercept = yMean - slope * xMean;

  return intercept;
}