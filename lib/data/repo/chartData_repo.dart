import 'package:calibration_curve/data/source/chartData_source.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../chartData.dart';

const String boxName = 'chartdatabox';

final chartDataRepo =
    ChatrDataLocalRepo(ChatrDataLocalDataSource(Hive.box<ChartData>(boxName)));

abstract class IChartDataRepo {
  Future<void> deletAll();
  Future<List<ChartData>> getAll();
  Future<ChartData> creatOrUpdate(ChartData data);
  Future<void> delete(ChartData data);
}

class ChatrDataLocalRepo with ChangeNotifier implements IChartDataRepo {
  final IChartDataDataSource localDataSource;

  ChatrDataLocalRepo(this.localDataSource);
  @override
  Future<ChartData> creatOrUpdate(ChartData data) async {
    final chartData = await localDataSource.creatOrUpdate(data);
    notifyListeners();
    return chartData;
  }

  @override
  Future<void> deletAll() async {
    await localDataSource.deletAll();
    notifyListeners();
  }

  @override
  Future<void> delete(ChartData data) async {
    await localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<List<ChartData>> getAll() {
    return localDataSource.getAll();
  }
}
