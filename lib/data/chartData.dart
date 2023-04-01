import 'package:hive_flutter/adapters.dart';
part 'chartData.g.dart';

@HiveType(typeId: 0)
class ChartData extends HiveObject{
  @HiveField(0)
   double x=1;
   @HiveField(1)
   double y=1;

  ChartData(this.x, this.y);
}