
import 'package:calibration_curve/data/chartData.dart';
import 'package:hive_flutter/adapters.dart';

abstract class IChartDataDataSource {
  Future<void> deletAll();
  Future<List<ChartData>> getAll();
  Future<ChartData> creatOrUpdate(ChartData data);
  Future<void> delete(ChartData data);
}

class ChatrDataLocalDataSource implements IChartDataDataSource {
  final Box<ChartData> box;

  ChatrDataLocalDataSource(this.box);
  @override
  Future<List<ChartData>> getAll() async {
    return await box.values.toList();
  }

  @override
  Future<void> deletAll() async {
    await box.clear();
  }

  @override
  Future<ChartData> creatOrUpdate(ChartData data) async {
    if (data.isInBox) {
      await data.save();
    } else {
      await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(ChartData data) async {
    return await data.delete();
  }
}
